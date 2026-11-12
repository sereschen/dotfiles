# Personal Pi module

Portable Pi configuration, public extension pins, compact context management, and
read-only research/review roles. This is a separate Stow package; `setup.sh` does
not install it. No private provider, company workflow, credentials, notes, sessions,
plugin source, or installation cache is included.

## What is included

| Path | Purpose |
| --- | --- |
| `.pi/agent/settings.json` | Provider-neutral UI/context preferences and pinned public packages |
| `.pi/agent/AGENTS.md` | Lead-owned implementation, bounded research, independent review and safety |
| `.pi/agent/agents/` | Fresh-context scout and reviewer; both inherit the selected model |
| `.pi/agent/extensions/subagent/config.json` | Async children, fresh context, no automatic resume after restart |
| `.pi/agent/skills/work-context/` | On-demand work-note workflow and optional templates |
| `.pi/agent/prompts/` | `/context-checkpoint` and `/context-resume` |
| `.pi/agent/MAINTENANCE.md` | Manual compatibility and package-upgrade checklist |
| `.pi-lens/config.json` | Preserve the disabled navigation-tool workaround |
| `docs/audit.md` | What was retained, omitted, and deliberately changed |

The agent directory and lens config use their default home-relative locations.
If you set `PI_CODING_AGENT_DIR` or `PI_LENS_CONFIG_PATH`, translate these paths to
your chosen locations; Stow does not expand environment variables inside filenames.

## Prerequisites and dependencies

Install Pi separately using its [official instructions](https://pi.dev). This
baseline was checked against **Pi 1.5.2** on macOS. Pi requires Node 22.19+ when
using the npm distribution; the repository's optional validation script uses
Node 24.15+ for native TypeScript support. No new script runtime is installed.

These MIT-licensed packages are declared, not vendored:

| Package | Pinned version | Purpose |
| --- | --- | --- |
| `pi-lens` | 4.4.12 | Code intelligence, source-body reads, diagnostics, AST tools |
| `pi-web-access` | 0.47.0 | Search and source retrieval |
| `pi-subagents` | 0.88.0 | Native async research/review, supervisor requests and retained runs |
| `pi-intercom` | 0.18.1 | Explicitly requested session kickoffs and messaging |
| `pi-obsidian` | 0.2.3 | Optional integration with an existing Obsidian vault |
| `@howaboua/pi-subdir-agents` | 0.0.9 | Load nested instructions on discovery without rewriting the prompt head |

Pi manages extension dependencies. Do not copy `node_modules`, Pi's npm manifest,
package caches, or local transitive lockfiles from another machine. The nested
instruction loader supports a tool-result fallback without its optional Codex
adapter; that adapter is not added to this baseline.

`pi-lens` may download language servers and analysis binaries when first used.
For an isolated check with no managed downloads, set both
`PI_LENS_DISABLE_LSP_INSTALL=1` and `PI_LENS_DISABLE_TOOL_INSTALL=1`. These are
process environment controls, not a promise that arbitrary extensions are sandboxed.
The navigation tool stays disabled pending a provider-specific compatibility
check; this does not disable LSP-backed diagnostics or source-symbol tools.

Optional tools: `git`/`rg` support code and notes discovery; `gh` supports the
optional PR extension below; `ffmpeg`/`yt-dlp` enable video-frame extraction in
web access. Obsidian is required only for its vault integration; no Dataview,
Tasks, Bases or Kanban plugin is required by the plain-Markdown context workflow.
No API keys, browser cookies, vault registry, or MCP endpoints are configured here.
Authenticate your own provider through Pi's `/login` after installation. The
settings deliberately do not select a provider or model unavailable on your Mac.

## Install on a personal machine

First inspect the package and test without modifying your real home. Review any
`.stowrc` in your home and current directory: Stow reads options from both, so
`--adopt` there would also affect the commands below. Remove that option before
using these instructions; changing only the target directory does not isolate it.

```sh
sandbox="$(mktemp -d)"
stow --no-folding --simulate --verbose --target="$sandbox" pi
```

For a new personal installation without conflicting files, from the repository root:

```sh
stow --no-folding --simulate --verbose --target="$HOME" pi
stow --no-folding --verbose --target="$HOME" pi
```

The package's ignore file keeps its README, audit and tests out of your home.
`--no-folding` keeps runtime directories real so new auth, session and cache files
cannot land in the dotfiles checkout through a directory symlink. Stow links only
reviewed configuration files. It must not adopt, overwrite, or delete
existing files. If the simulation reports conflicts, stop and compare them first.
Pi updates settings at runtime, so a Stow-linked settings file may change in Git;
review those changes rather than automatically committing runtime history.

Start Pi only when you are ready for package resolution: configured packages may
be installed at startup. Pinning makes the requested versions explicit, not a
sandbox or guarantee against transitive updates. You can explicitly reconcile
packages with `pi update --extensions` after reviewing their sources. This task
did not install packages, restow the live machine, reload sessions, or replace
its existing work configuration.

**Do not run this package over a managed work setup.** Generated global
instructions, settings, role links, and lens configuration may already belong to
another installer. Do not use `stow --adopt`. For an existing personal installation,
compare and merge reviewed settings manually; preserve auth, custom models, MCP,
local extensions, skills and sessions. Pi has no automatic `settings.local.json`
overlay. If you need machine-specific settings, keep `settings.json` as a real
local file containing the reviewed baseline plus your overrides instead of
linking that one file. Keep local model/auth files outside Git. A separate agent
directory can isolate the whole setup; changing its path alone does not create a
settings overlay.

## Daily workflow

- Start in the actual repository/worktree. The lead implements and tests.
- Use one bounded scout for substantial research and one fresh reviewer after
  checks pass. Both inherit the active model; select role-specific models in
  local `subagents.agentOverrides` only when needed.
- Update existing task notes at meaningful milestones. Keep Overview, actions,
  decisions and dated evidence separate. Default task notes live in the local
  Obsidian vault at `~/work-context/` (`~/work-context/tasks/<stable-id>/Overview.md`)
  unless a workspace establishes its own notes location. The skill includes
  optional templates, not a copied vault or automatic note generator.
- Use `/context-checkpoint [focus]` before a long-session transition, and
  `/context-resume <Overview path or task id>` to start from durable context.
  `/compact` and session replacement remain separate explicit actions.
- Compaction uses Pi defaults. Streaming cache warming is copied from the current
  preference; it may make extra provider requests during active runs and does
  not guarantee cache hits. Change it locally to `off` if unsuitable.
- A disconnect is not permission to replay partial work. Automatic child resume
  is disabled; inspect saved results and continue the same run explicitly.
- Intercom availability does not authorize progress broadcasts or monitoring.

## Optional PR status

The audit also found `@narumitw/pi-github-pr@0.49.10`. It is deliberately omitted
from the default package list because it polls GitHub on startup, every minute,
and after agent turns. If you want that behavior on your personal machine,
review its source and explicitly install it:

```sh
pi install npm:@narumitw/pi-github-pr@0.49.10
```

It requires your own authenticated `gh`. No watcher or recurring job is added
by the context workflow itself.

## Verification

From the repository root:

```sh
node --test pi/tests/config.test.ts
```

The tests run GNU Stow with temporary HOME/cwd/target directories and disposable
package copies. They check repeatable file-only linking, conflict refusal even
when the parent environment enables adoption, and configuration boundaries.
They do not launch Pi, contact providers, install packages, modify the source
package, or modify real notes. On a machine
with Pi already installed, resource discovery and schema checks can additionally
be run against its SDK in isolation. A successful offline discovery check is not
a live model call or proof of every third-party integration. Linux behavior and
Obsidian rendering have not been verified.
