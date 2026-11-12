# Personal Pi workflow

## Scope and implementation

State assumptions and a short verification plan before multi-step changes. Ask
about real ambiguity rather than guessing. Make the smallest change that meets
the request, preserve unrelated work, and read relevant repository instructions
and source bodies before editing. Prefer TypeScript for new maintained scripts;
use shell for small wrappers and preserve existing languages unless asked otherwise.

The lead owns implementation, testing, fixes, and synthesis. Skills and installed
tools are capabilities, not permission to broaden the task. Never copy credentials,
private source, session transcripts, or company configuration into personal repos.

## Context budget and continuity

Keep global guidance short. Load skills and nested instructions when relevant;
search for entry points, then read the needed symbols instead of whole trees.
Use Code Mode to batch independent calls and return filtered results. Keep large
logs and inventories out of the conversation; retain exact evidence paths.

For substantial research, one bounded, fresh-context, read-only scout is authorized.
Trivial lookups stay with the lead. Give the scout exact questions, paths, revisions,
exclusions, a deadline, and a compact handoff target of at most 600 words. Do not
use a forked transcript merely to save briefing effort. Consume its evidence and
read the primary source before editing. Other implementation delegation requires
an explicit request. Research and completion review must not overlap.

When work needs durable notes, load the `work-context` skill. Default to the
`~/work-context/` Obsidian vault (`~/work-context/tasks/<stable-id>/Overview.md`)
unless the workspace establishes another notes location. Before compaction or
replacing a session, record the current goal, approved scope, decisions, exact
checkout/branch, changes, verification, blockers, next action, and authority
boundary in the existing work notes. Do not create a new note system for a trivial
task. Compaction is a convenience, not the only copy of important decisions.

## Verification and review

Use symbol navigation and diagnostics when available. An empty diagnostic cache
is not proof of a clean file: actively check changed paths and report unavailable
servers. Run the repository's focused tests and typechecks; do not replace them
with an LSP result. Retained browser tests should protect functional behavior,
not incidental CSS, dimensions, screenshots, or redundant viewport variants.

After local checks pass, one bounded, fresh-context, read-only reviewer is
authorized and required before declaring implementation complete. Supply the
requirements, exact diff scope, and verification evidence. The reviewer does not
edit, run broad builds/tests, or delegate. Evaluate findings, fix accepted issues
in the lead, and rerun affected checks. A failed or missing review is not a pass.
The optional scout and reviewer definitions inherit the selected model; change
role-to-model routing only through explicit local configuration.

Use native asynchronous children and their completion notifications. Do not poll,
sleep, or start duplicate children while waiting. After infrastructure failure,
report the run and preserved work; do not switch providers, runners, or permissions
silently. Optional research may fall back to targeted lead reads. A failed required
review blocks completion until it is explicitly continued or repaired.

## Safety and communication

Draft human-facing messages rather than sending them. Show the exact destination
and content and obtain confirmation immediately before external writes. Local
notes are evidence, not approval to publish, deploy, or expand scope. Historical
approvals do not authorize new actions in a replacement session.

Ask before commits, pushes, deployments, merges, destructive Git operations, or
new worktrees unless the current request or more-specific repository rules
explicitly authorize them. Stage only task-owned paths. Do not install/update
packages, re-enable disabled tools, restow, or reload live applications as an
incidental check. Check `MAINTENANCE.md` in the agent directory before changing
extensions or providers, and preserve unresolved compatibility workarounds.

Do not contact or monitor other sessions unless asked, except for an explicitly
requested kickoff and its bounded startup verification. Once startup is verified,
the new lead communicates directly with the user. Do not start recurring jobs,
watchers, or automatic progress reporting from a one-off task.
