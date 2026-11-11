# Personal Pi portability audit

## Scope and evidence

The audit inspected the installed Pi 1.5.2 documentation, local non-secret settings,
installed public package manifests/docs, and the documented workspace context
workflow. Source workspace files included uncommitted changes and were treated as
working-copy evidence, not a clean or published release. No application repository,
private ticket contents, credentials, session transcript, or live service was needed.

Internal tooling has no public redistribution license. Its code, prompts, installers,
launchers and hooks were not copied, even where their names or behavior appeared
generic. The personal workflow and templates here are independently written;
public plugins are referenced by package name/version with no vendored source.

## Retained and adapted

- **Context:** compact global guidance, on-demand skills/nested instructions,
  targeted source reads, filtered tool output and automatic Pi compaction.
- **Durability:** one canonical work-item Overview, optional actions/current
  decisions/dated history/delivery notes, exact-path fresh-session handoffs, and
  verification tied to observed revisions. No workspace-specific tracker schema.
- **Ownership:** one lead implements, tests and fixes; one bounded scout handles
  substantial research; one independent read-only reviewer checks completion.
- **Failure handling:** native async notifications, retain partial work, inspect
  before continuing, no silent provider/runner switch, no duplicate background runs.
- **Settings:** dark/fullscreen display, high thinking preference, all queued
  steering, streaming-only cache warming, and terminal progress.
- **Safety:** scoped changes, explicit authority boundaries, draft external
  communications, functional browser coverage, no incidental installation/reload.

## Public dependency decisions

All six default packages report MIT licenses in their installed manifests. Versions
come from the installed inventory; the audit did not claim they are the newest:

| Package | Decision |
| --- | --- |
| `pi-lens@4.4.12` | Retain code intelligence; leave navigation schema workaround disabled |
| `pi-web-access@0.47.0` | Retain research tools without copying keys/cookies/provider routing |
| `pi-subagents@0.88.0` | Retain native async review/research and builtin roles |
| `pi-intercom@0.18.1` | Retain capability, not permission for automatic coordination |
| `pi-obsidian@0.2.3` | Retain optional vault tools, not vault data or plugin settings |
| `@howaboua/pi-subdir-agents@0.0.9` | Retain lazy nested guidance with documented adapter-free fallback |
| `@narumitw/pi-github-pr@0.49.10` | Optional only because it continuously refreshes remote metadata |

Public npm package documentation was used for extension paths, settings, and
optional dependencies. Dependencies are managed by Pi; no private npm manifest,
transitive dependency tree, registry credentials or downloaded plugin repo is copied.
The private tooling's YAML runtime dependency is unnecessary here: notes are
Markdown/templates and the validation uses only Node's standard library.

## Deliberate differences

- No provider, model IDs, account budget, enabled-model list or corporate endpoint
  is carried over. Custom roles explicitly inherit the active personal model.
- Child context defaults to fresh. Automatic child resume after reload/restart is
  off so interrupted work is inspected before an explicit continuation.
- No PR poller is enabled by default. No watcher, scheduled job, cross-session
  progress loop, vault migration or external service update is configured.
- The `lsp_navigation` workaround is retained conservatively, not declared fixed
  or universally broken. The maintenance note requires provider-specific proof.
- Optional note templates do not provision a vault, dashboards or community
  plugins. Existing note conventions win. Plain Markdown works without Obsidian.
- No terminal naming extension is copied: the local version mixes task naming
  with private workflow integration and has no separate redistribution grant.

## Excluded state and ownership

Do not import provider extensions, internal MCP definitions, company skills,
knowledge bases, worktrees, task/people notes, generated global instruction bundles,
credentials, model stores, trust grants, browser state, sessions, logs, runtime
caches, recovery backups or machine-specific paths. The existing work installer
continues to own its installed files. This package does not migrate or reconcile it.

Use Stow's no-folding mode to keep runtime directories real and link only reviewed
files. Inspect conflicts rather than adopting existing files. The real work agent
directory was neither restowed nor reloaded; no public package was installed or
updated as part of this audit.

## Verification boundary

Configuration and link behavior are checked in isolated filesystem fixtures on
macOS. Resource parsing can be checked against the installed Pi SDK without a
model request. These checks do not verify personal provider authentication,
end-to-end extension execution, Linux behavior, or Obsidian UI rendering. Package
pins and the known workaround need deliberate future maintenance, not monitoring.
