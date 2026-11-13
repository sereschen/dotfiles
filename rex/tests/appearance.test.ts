import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { cpSync, existsSync, mkdtempSync, mkdirSync, readFileSync, readdirSync, rmSync, statSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import test from 'node:test';

const script = new URL('../appearance.ts', import.meta.url);
const mac = process.platform === 'darwin';
const plist = (body: string) => `<?xml version="1.0" encoding="UTF-8"?><plist version="1.0"><dict>${body}</dict></plist>`;
const native = (bin: string, args: string[], input?: string) => {
  const result = spawnSync(bin, args, { input, encoding: 'utf8' });
  assert.equal(result.status, 0, result.stderr || result.stdout);
  return result.stdout;
};

// Dynamic import keeps the first red run an assertion about the missing feature.
async function api() {
  const module = await import(script.href).catch(() => null);
  assert(module, 'appearance workflow must exist');
  return module;
}

test('capture selects only appearance, decodes theme data and records absent defaults', { skip: !mac }, async () => {
  const { capturePreferences, validateSnapshot } = await api();
  const themes = [{ id: 'custom-test', name: 'Test', palette: { background: '#112233' } }];
  const source = plist(`<key>Workspace.customThemes</key><data>${Buffer.from(JSON.stringify(themes)).toString('base64')}</data>
    <key>Workspace.darkThemeID</key><string>custom-test</string>
    <key>Workspace.sidebarShowsActivity</key><false/>
    <key>Workspace.terminalFontPointSize</key><real>13.5</real>
    <key>Workspace.terminalFallbackFontNames</key><array><string>Test Font</string></array>
    <key>RexSync.servers</key><string>private-host</string>
    <key>Workspace.lastFocusedSession</key><string>private-session</string>
    <key>Workspace.sidebarWidth</key><real>277</real>
    <key>Workspace.terminalStartupCommand</key><string>private-command</string>`);
  const snapshot = capturePreferences(source);
  assert.deepEqual(snapshot.preferences['Workspace.customThemes'], { type: 'data', value: themes });
  assert.deepEqual(snapshot.preferences['Workspace.darkThemeID'], { type: 'string', value: 'custom-test' });
  assert.deepEqual(snapshot.preferences['Workspace.sidebarShowsActivity'], { type: 'bool', value: false });
  assert.deepEqual(snapshot.preferences['Workspace.terminalFontPointSize'], { type: 'float', value: 13.5 });
  assert.deepEqual(snapshot.preferences['Workspace.terminalFallbackFontNames'], { type: 'array', value: ['Test Font'] });
  assert.equal(snapshot.preferences['Workspace.terminalFontName'], null);
  assert(!JSON.stringify(snapshot).match(/private-|sidebarWidth|StartupCommand|RexSync/));
  assert.deepEqual(validateSnapshot(JSON.parse(JSON.stringify(snapshot))), snapshot);
});

test('snapshot validation rejects unknown keys, invalid types and incomplete snapshots', async () => {
  const { validateSnapshot, preferenceKeys } = await api();
  const blank = () => ({ version: 1, preferences: Object.fromEntries(preferenceKeys.map((key: string) => [key, null])) });
  assert.throws(() => validateSnapshot({ ...blank(), version: 2 }), /version/i);
  assert.throws(() => validateSnapshot({ ...blank(), private: 'host' }), /field/i);
  const unknown = blank();
  unknown.preferences['RexSync.servers'] = null;
  assert.throws(() => validateSnapshot(unknown), /keys/i);
  const missing = blank();
  delete missing.preferences['Workspace.darkThemeID'];
  assert.throws(() => validateSnapshot(missing), /keys/i);
  for (const entry of [
    { type: 'bool', value: 'false' }, { type: 'float', value: Infinity },
    { type: 'integer', value: 1.5 }, { type: 'string', value: {} },
    { type: 'array', value: [false] }, { type: 'data', value: 'not JSON theme data' },
    { type: 'string', value: 'x', extra: true }, { type: 'dictionary', value: {} },
  ]) {
    const invalid = blank();
    invalid.preferences['Workspace.darkThemeID'] = entry;
    assert.throws(() => validateSnapshot(invalid), /preference|type|field/i);
  }
});

test('comma-combined unknown keys are rejected before any preference writes', { skip: !mac }, async () => {
  const { validateSnapshot, applyPreferences, preferenceKeys } = await api();
  const preferences = Object.fromEntries(preferenceKeys.map((key: string) => [key, null]));
  const first = 'Workspace.terminalFontName';
  const second = 'Workspace.terminalFontPointSize';
  delete preferences[first];
  delete preferences[second];
  preferences[`${first},${second}`] = null;
  preferences['Workspace.darkThemeID'] = { type: 'string', value: 'must-not-be-written' };
  const malformed = { version: 1, preferences };
  const root = mkdtempSync(join(tmpdir(), 'rex-invalid-snapshot-test-'));
  const domain = join(root, 'preferences');
  try {
    writeFileSync(`${domain}.plist`, plist('<key>Workspace.darkThemeID</key><string>original</string>'));
    const before = readFileSync(`${domain}.plist`);
    let failure: unknown;
    try { applyPreferences(domain, malformed); } catch (error) { failure = error; }
    assert.deepEqual(readFileSync(`${domain}.plist`), before, 'invalid keys must not cause partial writes');
    assert.match(String(failure), /preference keys/i);
    assert.throws(() => validateSnapshot(malformed), /preference keys/i);
  } finally { rmSync(root, { recursive: true, force: true }); }
});

test('capture fails closed for malformed plist or unexpected binary data', { skip: !mac }, async () => {
  const { capturePreferences } = await api();
  assert.throws(() => capturePreferences('not a plist'), /plutil|plist/i);
  assert.throws(() => capturePreferences(plist('<key>Workspace.customThemes</key><data>aGVsbG8=</data>')), /JSON|data/i);
});

test('apply preserves unrelated preferences, restores defaults, and round-trips all supported types', { skip: !mac }, async () => {
  const { capturePreferences, applyPreferences } = await api();
  const root = mkdtempSync(join(tmpdir(), 'rex-appearance-test-'));
  const domain = join(root, 'preferences');
  try {
    writeFileSync(`${domain}.plist`, plist('<key>RexSync.servers</key><data>AQID</data><key>Workspace.terminalFontName</key><string>Other Font</string>'));
    const source = plist(`<key>Workspace.darkThemeID</key><string>Test &amp; &lt;Theme&gt;</string>
      <key>Workspace.customThemes</key><data>${Buffer.from('[{"id":"custom-test","name":"Test","palette":{}}]').toString('base64')}</data>
      <key>Workspace.sidebarShowsActivity</key><false/>
      <key>Workspace.terminalFontPointSize</key><real>14.5</real>
      <key>Workspace.tabIconCount</key><integer>2</integer>
      <key>Workspace.terminalFallbackFontNames</key><array><string>Test &amp; Font</string><string>Second Font</string></array>`);
    const snapshot = capturePreferences(source);
    applyPreferences(domain, snapshot);
    const applied = native('/usr/bin/defaults', ['export', domain, '-']);
    assert.deepEqual(capturePreferences(applied), snapshot);
    assert.equal(native('/usr/bin/plutil', ['-extract', 'RexSync\\.servers', 'raw', '-o', '-', '-'], applied).trim(), 'AQID');
    applyPreferences(domain, { ...snapshot, preferences: Object.fromEntries(Object.entries(snapshot.preferences).reverse()) });
    assert.deepEqual(capturePreferences(native('/usr/bin/defaults', ['export', domain, '-'])), snapshot);
    const before = readFileSync(`${domain}.plist`);
    assert.throws(() => applyPreferences(domain, { ...snapshot, preferences: { ...snapshot.preferences, 'rex.client.remoteControl': { type: 'bool', value: true } } }), /keys/i);
    assert.deepEqual(readFileSync(`${domain}.plist`), before);
  } finally {
    rmSync(root, { recursive: true, force: true });
  }
});

test('backup contains only selected preferences and restores the full baseline safely', { skip: !mac }, async () => {
  const { backupPreferences, capturePreferences, applyPreferences } = await api();
  assert.equal(typeof backupPreferences, 'function', 'selected-preference backup must exist');
  const root = mkdtempSync(join(tmpdir(), 'rex-backup-test-'));
  const domain = join(root, 'preferences');
  try {
    writeFileSync(`${domain}.plist`, plist('<key>RexSync.servers</key><string>private-host</string><key>Workspace.darkThemeID</key><string>original</string>'));
    const backup = backupPreferences(domain, join(root, 'backups'));
    const saved = readFileSync(backup, 'utf8');
    assert(!saved.includes('private-host'));
    assert.equal(statSync(backup).mode & 0o777, 0o600);
    assert.equal(statSync(join(root, 'backups')).mode & 0o777, 0o700);
    assert.equal(capturePreferences(native('/usr/bin/defaults', ['export', domain, '-'])).preferences['Workspace.darkThemeID'].value, 'original');
    const baseline = JSON.parse(readFileSync(new URL('../appearance.json', import.meta.url), 'utf8'));
    applyPreferences(domain, baseline);
    assert.deepEqual(capturePreferences(native('/usr/bin/defaults', ['export', domain, '-'])), baseline);
    applyPreferences(domain, JSON.parse(saved));
    assert.equal(capturePreferences(native('/usr/bin/defaults', ['export', domain, '-'])).preferences['Workspace.darkThemeID'].value, 'original');
    assert.equal(native('/usr/bin/defaults', ['read', domain, 'RexSync.servers']).trim(), 'private-host');
  } finally { rmSync(root, { recursive: true, force: true }); }
});

test('CLI help and invalid usage do not require or modify Rex', () => {
  const help = spawnSync(process.execPath, [script.pathname, '--help'], { encoding: 'utf8' });
  assert.equal(help.status, 0, help.stderr);
  assert.match(help.stdout, /export.*preview.*apply/s);
  const bad = spawnSync(process.execPath, [script.pathname, 'apply', '--surprise'], { encoding: 'utf8' });
  assert.notEqual(bad.status, 0);
  assert.match(bad.stderr, /usage|argument/i);
});

test('apply refuses without confirmation or while Rex is running, without changing live preferences', { skip: !mac }, async () => {
  const noConfirm = spawnSync(process.execPath, [script.pathname, 'apply'], { encoding: 'utf8' });
  assert.notEqual(noConfirm.status, 0);
  assert.match(noConfirm.stderr, /requires --yes/i);
  if (spawnSync('/usr/bin/pgrep', ['-x', 'Rex']).status !== 0) return;
  const { requireStoppedRex } = await api();
  assert.throws(() => requireStoppedRex(), /quit the Rex app first/i);
});

test('Stow installs only the hidden Rex config, not the appearance workflow or tests', () => {
  const root = mkdtempSync(join(tmpdir(), 'rex-stow-test-'));
  try {
    const home = join(root, 'home');
    const repository = join(root, 'repository');
    mkdirSync(home);
    mkdirSync(repository);
    cpSync(new URL('..', import.meta.url), join(repository, 'rex'), { recursive: true });
    const result = spawnSync('stow', ['--dir', repository, '--target', home, 'rex'], { cwd: root, env: { ...process.env, HOME: home }, encoding: 'utf8' });
    assert.equal(result.status, 0, result.stderr);
    assert.deepEqual(readdirSync(home), ['.config']);
    assert(existsSync(join(home, '.config/rex/init.lua')));
  } finally { rmSync(root, { recursive: true, force: true }); }
});

test('committed baseline is valid, has the selected theme and excludes private state', async () => {
  const { validateSnapshot } = await api();
  const text = readFileSync(new URL('../appearance.json', import.meta.url), 'utf8');
  const baseline = validateSnapshot(JSON.parse(text));
  assert.equal(baseline.preferences['Workspace.tabStyle'].value, 'vertical');
  assert.equal(baseline.preferences['Workspace.sidebarPosition'].value, 'right');
  const selected = baseline.preferences['Workspace.darkThemeID'].value;
  assert(baseline.preferences['Workspace.customThemes'].value.some((theme: { id: string }) => theme.id === selected));
  assert(!/\/Users\/|\/opt\/homebrew|RexSync|lastFocusedSession|remoteControl|sidebarWidth/.test(text));
});
