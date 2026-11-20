import { spawnSync } from 'node:child_process';
import { mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { homedir } from 'node:os';
import { join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

// Explicit visual-only keys observed in Rex preview.14. Never select by prefix.
export const preferenceKeys = [
  'activePaneBorderColor', 'activePaneBorderOpacity', 'activePaneBorderTransition',
  'appearance', 'customThemes', 'darkThemeID', 'darkUsesExtendedThemePalette',
  'inactivePaneFadeMode', 'inactiveWindowPaneFadeMode', 'interfaceStyle',
  'lightThemeID', 'lightUsesExtendedThemePalette', 'paneDensity', 'paneHeaderVisibility',
  'shellIconTheme', 'showsActivePaneBorder', 'showsPaneHeaders',
  'sidebarPosition', 'sidebarShowsActivity', 'sidebarTextPointSize',
  'tabIconColorMode', 'tabIconCount', 'tabIconTintMode', 'tabsFillAvailableSpace', 'tabStyle',
  'terminalAllowsLigatures', 'terminalCellHeightPercent', 'terminalCharacterSpacing',
  'terminalCursorBlinkIntervalMilliseconds', 'terminalCursorBlinkUsesCustomInterval',
  'terminalCursorStyle', 'terminalCursorStyleForced', 'terminalFallbackFontNames',
  'terminalFontName', 'terminalFontPointSize', 'terminalFontSmoothing',
  'terminalFontStyle', 'terminalFontWeight', 'terminalImproveTextContrast',
  'terminalPaddingColor', 'terminalPaddingX', 'terminalPaddingY',
  'terminalSelectionBackground', 'terminalSelectionForeground', 'terminalSelectionRoundedCorners',
  'terminalSynthesizesMissingStyles', 'terminalUsesBoldFace', 'terminalUsesDisplayP3',
  'terminalUsesItalicFace', 'terminalUseThemePalette', 'tintsPanesWithProgramBackground',
  'usesInactivePaneStylesInInactiveWindows', 'usesPaneGlass', 'usesStandardInactiveWindowPaneStyles',
].map((name) => `Workspace.${name}`).sort();

type Json = null | boolean | number | string | Json[] | { [key: string]: Json };
type Preference = { type: 'string' | 'bool' | 'integer' | 'float' | 'array' | 'data'; value: Json } | null;
export interface Snapshot { version: 1; preferences: Record<string, Preference> }
const domain = 'com.superlogical.rex';
const defaultFile = fileURLToPath(new URL('./appearance.json', import.meta.url));
const usage = 'Usage: node rex/appearance.ts export|preview|apply [snapshot.json] [--yes (apply only)]';

function command(binary: string, args: string[], input?: string): string {
  const result = spawnSync(binary, args, { input, encoding: 'utf8', timeout: 10000, maxBuffer: 8 * 1024 * 1024 });
  if (result.error || result.status !== 0) {
    throw new Error(`${binary}: ${result.error?.message || result.stderr || result.stdout || `exit ${result.status}`}`);
  }
  return result.stdout;
}

function parseJson(text: string): Json {
  try {
    const value: unknown = JSON.parse(text);
    if (!jsonValue(value)) throw new Error('Expected finite JSON values');
    return value;
  } catch (error) {
    throw new Error(`Invalid appearance JSON/data: ${error instanceof Error ? error.message : error}`);
  }
}

function object(value: unknown): value is Record<string, unknown> {
  return value !== null && typeof value === 'object' && !Array.isArray(value);
}

function jsonValue(value: unknown): value is Json {
  if (value === null || typeof value === 'string' || typeof value === 'boolean') return true;
  if (typeof value === 'number') return Number.isFinite(value);
  if (Array.isArray(value)) return value.every(jsonValue);
  return object(value) && Object.values(value).every(jsonValue);
}

// Stable nested ordering makes exported palette diffs useful.
function canonical(value: Json): Json {
  if (Array.isArray(value)) return value.map(canonical);
  if (object(value)) return Object.fromEntries(Object.keys(value).sort().map((key) => [key, canonical(value[key] as Json)]));
  return value;
}

function hasExactKeys(value: Record<string, unknown>, expected: readonly string[]): boolean {
  return Object.keys(value).length === expected.length && expected.every((key) => Object.hasOwn(value, key));
}

export function validateSnapshot(input: unknown): Snapshot {
  if (!object(input) || input.version !== 1) throw new Error('Unsupported snapshot version');
  if (!hasExactKeys(input, ['preferences', 'version'])) throw new Error('Unexpected snapshot fields');
  const preferences = input.preferences;
  if (!object(preferences) || !hasExactKeys(preferences, preferenceKeys)) {
    throw new Error('Snapshot preference keys must exactly match the visual allowlist');
  }
  for (const [key, entry] of Object.entries(preferences)) {
    if (entry === null) continue; // Explicitly return to Rex's default.
    if (!object(entry) || !hasExactKeys(entry, ['type', 'value'])) throw new Error(`Invalid preference fields: ${key}`);
    const { type, value } = entry;
    const valid = type === 'string' ? typeof value === 'string'
      : type === 'bool' ? typeof value === 'boolean'
      : type === 'integer' ? typeof value === 'number' && Number.isSafeInteger(value)
      : type === 'float' ? typeof value === 'number' && Number.isFinite(value)
      : type === 'array' ? Array.isArray(value) && value.every((item) => typeof item === 'string')
      : type === 'data' ? (object(value) || Array.isArray(value)) && jsonValue(value)
      : false;
    if (!valid) throw new Error(`Invalid preference type/value: ${key}`);
  }
  // SAFETY: the exact schema, allowlist, discriminants and values were checked above.
  return input as unknown as Snapshot;
}

export function capturePreferences(xml: string): Snapshot {
  command('/usr/bin/plutil', ['-lint', '-'], xml);
  const preferences: Record<string, Preference> = {};
  for (const key of preferenceKeys) {
    const keypath = key.replaceAll('.', '\\.');
    const probe = spawnSync('/usr/bin/plutil', ['-type', keypath, '-'], { input: xml, encoding: 'utf8', timeout: 10000 });
    if (probe.error) throw probe.error;
    if (probe.status !== 0) {
      if (!`${probe.stdout}${probe.stderr}`.includes('No value at that key path')) throw new Error(`plutil: ${probe.stderr || probe.stdout}`);
      preferences[key] = null;
      continue;
    }
    const type = probe.stdout.trim();
    let value: Json;
    if (type === 'data') {
      const base64 = command('/usr/bin/plutil', ['-extract', keypath, 'raw', '-o', '-', '-'], xml).trim();
      value = parseJson(Buffer.from(base64, 'base64').toString('utf8'));
    } else if (type === 'array') {
      value = parseJson(command('/usr/bin/plutil', ['-extract', keypath, 'json', '-o', '-', '-'], xml));
    } else {
      const raw = command('/usr/bin/plutil', ['-extract', keypath, 'raw', '-n', '-o', '-', '-'], xml);
      value = type === 'string' ? raw : parseJson(raw);
    }
    preferences[key] = { type, value: canonical(value) } as Preference;
  }
  return validateSnapshot({ version: 1, preferences });
}

function readPreferences(target: string): Snapshot {
  return capturePreferences(command('/usr/bin/defaults', ['export', target, '-']));
}

function xmlString(value: string): string {
  return `<string>${value.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;')}</string>`;
}

export function applyPreferences(target: string, input: unknown): void {
  const snapshot = validateSnapshot(input); // Validate everything before any write.
  const before = readPreferences(target);
  for (const key of preferenceKeys) {
    const entry = snapshot.preferences[key];
    if (JSON.stringify(canonical(entry)) === JSON.stringify(canonical(before.preferences[key]))) continue;
    if (entry === null) {
      command('/usr/bin/defaults', ['delete', target, key]);
      continue;
    }
    const { type, value } = entry;
    const args = type === 'data' ? ['-data', Buffer.from(JSON.stringify(value)).toString('hex')]
      : type === 'array' ? [`<array>${(value as string[]).map(xmlString).join('')}</array>`]
      : [`-${type}`, String(value)];
    command('/usr/bin/defaults', ['write', target, key, ...args]);
  }
  if (JSON.stringify(canonical(readPreferences(target).preferences)) !== JSON.stringify(canonical(snapshot.preferences))) {
    throw new Error('Appearance verification failed; restore the backup before retrying');
  }
}

export function requireStoppedRex(): void {
  const result = spawnSync('/usr/bin/pgrep', ['-x', 'Rex'], { encoding: 'utf8', timeout: 10000 });
  if (result.status === 0) throw new Error('Quit the Rex app first, then run apply from another terminal. The Rex server can stay running.');
  if (result.error || result.status !== 1) throw new Error('Could not determine whether Rex is running; refusing to apply');
}

function save(path: string, snapshot: Snapshot, exclusive = false): void {
  writeFileSync(path, `${JSON.stringify(snapshot, null, 2)}\n`, { mode: 0o600, flag: exclusive ? 'wx' : 'w' });
}

export function backupPreferences(target: string, backupDir: string): string {
  const snapshot = readPreferences(target);
  mkdirSync(backupDir, { recursive: true, mode: 0o700 });
  const backup = join(backupDir, `${new Date().toISOString().replaceAll(':', '-')}-${process.pid}.json`);
  save(backup, snapshot, true);
  return backup;
}

export function main(args: string[]): void {
  if (args.length === 1 && args[0] === '--help') { console.log(usage); return; }
  const [action, ...rest] = args;
  const paths = rest.filter((arg) => !arg.startsWith('--'));
  if (!['export', 'preview', 'apply'].includes(action) || paths.length > 1
    || rest.some((arg) => arg.startsWith('--') && (arg !== '--yes' || action !== 'apply'))
    || rest.filter((arg) => arg === '--yes').length > 1) throw new Error(usage);
  if (process.platform !== 'darwin') throw new Error('Rex appearance preferences require macOS');
  const file = resolve(paths[0] || defaultFile);
  if (action === 'export') {
    save(file, readPreferences(domain));
    console.log(`Exported visual preferences to ${file}. Review the diff before committing.`);
    return;
  }
  const snapshot = validateSnapshot(parseJson(readFileSync(file, 'utf8')));
  if (action === 'preview') {
    const current = readPreferences(domain);
    for (const key of preferenceKeys) {
      if (JSON.stringify(canonical(current.preferences[key])) !== JSON.stringify(canonical(snapshot.preferences[key]))) {
        console.log(`${key}: ${snapshot.preferences[key] === null ? 'reset to Rex default' : 'set from snapshot'}`);
      }
    }
    console.log('Preview only; no preferences changed.');
    return;
  }
  if (!rest.includes('--yes')) throw new Error('Apply requires --yes. Preview first, then quit Rex and run apply from another terminal.');
  requireStoppedRex();
  const backupDir = join(process.env.XDG_STATE_HOME || join(homedir(), '.local', 'state'), 'rex', 'appearance-backups');
  const backup = backupPreferences(domain, backupDir);
  console.log(`Selected-preference backup: ${backup}`);
  try { applyPreferences(domain, snapshot); }
  catch (error) { throw new Error(`${error instanceof Error ? error.message : error}\nRestore with: node rex/appearance.ts apply '${backup}' --yes`); }
  console.log('Applied and verified appearance preferences. Open Rex manually when ready.');
}

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  try { main(process.argv.slice(2)); }
  catch (error) { console.error(error instanceof Error ? error.message : error); process.exitCode = 1; }
}
