import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { cpSync, existsSync, lstatSync, mkdtempSync, mkdirSync, readFileSync, readdirSync, realpathSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { dirname, join, relative, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import test from 'node:test';

const packageRoot = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const read = (path: string) => readFileSync(join(packageRoot, path), 'utf8');
const settings = JSON.parse(read('.pi/agent/settings.json'));

function filesUnder(path: string): string[] {
  return readdirSync(path, { withFileTypes: true }).flatMap((entry) => {
    const child = join(path, entry.name);
    assert(!entry.isSymbolicLink(), `Unexpected source symlink: ${child}`);
    return entry.isDirectory() ? filesUnder(child) : [child];
  });
}

interface Fixture {
  root: string;
  home: string;
  cwd: string;
  repository: string;
}

function stow(fixture: Fixture, simulate = false) {
  return spawnSync('stow', [
    '--no-folding', ...(simulate ? ['--simulate'] : []),
    '--dir', fixture.repository, '--target', fixture.home, 'pi',
  ], {
    cwd: fixture.cwd,
    env: { ...process.env, HOME: fixture.home },
    encoding: 'utf8', timeout: 10000,
  });
}

function sandbox(run: (fixture: Fixture) => void) {
  const root = mkdtempSync(join(tmpdir(), 'pi-dotfiles-test-'));
  const fixture = {
    root, home: join(root, 'home'), cwd: join(root, 'cwd'),
    repository: join(root, 'repository'),
  };
  try {
    for (const path of [fixture.home, fixture.cwd, fixture.repository]) mkdirSync(path);
    cpSync(packageRoot, join(fixture.repository, 'pi'), { recursive: true });
    run(fixture);
  } finally { rmSync(root, { recursive: true, force: true }); }
}

test('provider-neutral preferences and exact public package pins', () => {
  assert.equal(settings.compaction.enabled, true);
  assert.equal(settings.cacheWarming, 'streaming');
  assert.equal(settings.defaultThinkingLevel, 'high');
  assert.equal(settings.steeringMode, 'all');
  assert.equal(settings.tuiMode, 'fullscreen');
  assert.equal(settings.terminal.showTerminalProgress, true);
  assert.deepEqual(Object.keys(settings).sort(), [
    '$schema', 'theme', 'defaultThinkingLevel', 'hideThinkingBlock', 'editorPaddingX',
    'terminal', 'tuiMode', 'steeringMode', 'cacheWarming', 'compaction', 'packages',
  ].sort());
  assert.deepEqual(settings.packages, [
    'npm:pi-lens@4.4.12', 'npm:pi-web-access@0.47.0',
    'npm:pi-subagents@0.88.0', 'npm:pi-intercom@0.18.1',
    'npm:pi-obsidian@0.2.3', 'npm:@howaboua/pi-subdir-agents@0.0.9',
  ]);
});

test('fresh async children require explicit recovery and navigation stays disabled', () => {
  assert.deepEqual(JSON.parse(read('.pi/agent/extensions/subagent/config.json')), {
    asyncByDefault: true, defaultSubagentContext: 'fresh', autoResume: false,
  });
  assert.equal(JSON.parse(read('.pi-lens/config.json')).tools.lsp_navigation.enabled, false);
  for (const role of ['scout', 'reviewer']) {
    const content = read(`.pi/agent/agents/${role}.md`);
    for (const field of ['model: inherit', 'async: true', 'defaultContext: fresh', 'inheritProjectContext: true', 'inheritGlobalContext: true', 'acceptanceRole: read-only']) {
      assert(content.includes(`\n${field}\n`), `${role} missing ${field}`);
    }
    assert(!/^tools:.*\b(?:write|edit|subagent|intercom|lsp_navigation)\b/m.test(content));
  }
  assert.match(read('.pi/agent/agents/reviewer.md'), /^tools: read, grep, find, ls$/m);
  assert.match(read('.pi/agent/agents/scout.md'), /^tools:.*\bcontact_supervisor\b/m);
});

test('skills and prompts use portable routing and valid local references', () => {
  const skill = read('.pi/agent/skills/work-context/SKILL.md');
  assert.match(skill, /^---\nname: work-context\ndescription: .+\n---\n/);
  assert(existsSync(join(packageRoot, '.pi/agent/skills/work-context/references/templates.md')));
  for (const command of ['context-checkpoint', 'context-resume']) {
    assert.match(read(`.pi/agent/prompts/${command}.md`), /^---\ndescription: .+\nargument-hint: .+\n---\n/);
  }
});

test('package contains no machine paths or copied runtime artifacts', () => {
  const files = filesUnder(packageRoot);
  const forbidden = /(?:\/Users\/|\/home\/[^\s/]+|\/opt\/homebrew|\/usr\/local)/;
  const privateFile = /^(?:auth\.json|mcp(?:-auth|-cache)?\.json|models(?:-store)?\.json|trust\.json|package-lock\.json)$/;
  for (const path of files) {
    const rel = relative(packageRoot, path);
    assert(!forbidden.test(readFileSync(path, 'utf8')), `Private or machine-specific content: ${rel}`);
    assert(!rel.split('/').some((part) => ['node_modules', 'sessions', 'cache', 'mcp-oauth'].includes(part) || privateFile.test(part)), `Runtime state: ${rel}`);
  }
});

test('Stow simulation is non-mutating; installation is file-only and repeatable', () => {
  sandbox((fixture) => {
    const { home, repository } = fixture;
    const dry = stow(fixture, true);
    assert.equal(dry.status, 0, dry.stderr || dry.error?.message || 'Stow simulation failed');
    assert.deepEqual(readdirSync(home), []);
    for (let attempt = 0; attempt < 2; attempt++) {
      const applied = stow(fixture);
      assert.equal(applied.status, 0, applied.stderr || applied.error?.message || 'Stow failed');
    }
    for (const dir of ['.pi', '.pi/agent', '.pi/agent/agents', '.pi/agent/extensions', '.pi-lens']) {
      const entry = lstatSync(join(home, dir));
      assert(entry.isDirectory() && !entry.isSymbolicLink(), `Folded runtime directory: ${dir}`);
    }
    for (const path of ['.pi/agent/settings.json', '.pi/agent/AGENTS.md', '.pi/agent/agents/scout.md', '.pi/agent/agents/reviewer.md', '.pi/agent/skills/work-context/SKILL.md', '.pi-lens/config.json']) {
      assert(lstatSync(join(home, path)).isSymbolicLink());
      assert.equal(realpathSync(join(home, path)), realpathSync(join(repository, 'pi', path)));
    }
    for (const excluded of ['README.md', 'docs', 'tests', 'config.test.ts']) assert(!existsSync(join(home, excluded)));
    writeFileSync(join(home, '.pi/agent/auth.json'), '{}');
    assert(!existsSync(join(repository, 'pi/.pi/agent/auth.json')));
    assert(!existsSync(join(packageRoot, '.pi/agent/auth.json')));
  });
});

test('Stow refuses conflicts even when the parent HOME and cwd enable adoption', () => {
  sandbox((fixture) => {
    const { home, repository, root } = fixture;
    const ambient = join(root, 'ambient');
    mkdirSync(ambient);
    writeFileSync(join(ambient, '.stowrc'), '--adopt\n');
    const agentDir = join(home, '.pi/agent');
    mkdirSync(agentDir, { recursive: true });
    const path = join(agentDir, 'settings.json');
    const original = '{"keep":"personal-local-settings"}\n';
    writeFileSync(path, original);
    const source = read('.pi/agent/settings.json');
    const previousHome = process.env.HOME;
    const previousCwd = process.cwd();
    let result: ReturnType<typeof stow>;
    try {
      process.env.HOME = ambient;
      process.chdir(ambient);
      result = stow(fixture);
    } finally {
      if (previousHome === undefined) delete process.env.HOME;
      else process.env.HOME = previousHome;
      process.chdir(previousCwd);
    }
    assert.notEqual(result.status, 0);
    assert.equal(readFileSync(join(repository, 'pi/.pi/agent/settings.json'), 'utf8'), source);
    assert.equal(read('.pi/agent/settings.json'), source);
    assert.equal(readFileSync(path, 'utf8'), original);
    assert(!lstatSync(path).isSymbolicLink());
    assert(!existsSync(join(agentDir, 'AGENTS.md')));
  });
});
