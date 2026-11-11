---
name: work-context
description: Maintain compact durable work notes and fresh-session handoffs for multi-step work, context checkpoints, or continuing a task without replaying chat history.
---

# Durable work context

Use an existing workspace note convention first. Ask where notes belong if there
is no established location. Do not turn a one-command task into a documentation
project, create an Obsidian vault, migrate existing notes, or copy private notes
into dotfiles as part of using this skill.

## Start or continue

1. Find the work item's canonical Overview through the workspace index or the exact
   path supplied by the user. If an identifier matches several notes, ask.
2. Read its goal, approved scope, current status, blockers, and next action. Read
   a linked parent project's Overview/Context first when it governs the work.
3. Read Todos and linked current Context only as relevant. Use History for a
   specific evidence question, not as a mandatory transcript replay.
4. Verify the actual repository, checkout, branch, and local changes. Notes about
   past commands, remote status, or approvals are not proof of their current state.

## Keep one source for each fact

Use `tasks/<stable-id>/Overview.md` when creating a new work item in an agreed
notes root. Add supporting files only when they earn their place:

- **Overview.md:** current goal, approved scope, stage, blockers, next action and
  links. This is the entry point, not a chronological log.
- **Todos.md:** questions and actionable checkboxes only. Decisions, command
  output and verification logs belong elsewhere.
- **Context.md:** current approved decisions, contracts, constraints and sources.
- **History.md:** dated decisions, significant checkpoints and verification evidence.
- **deliveries/<name>.md:** optional independently reviewed change, normally one
  pull request. Track its exact checkout/branch/revision and external observations.
- **docs/:** knowledge useful beyond one task; link it instead of copying it.

See [the note templates](references/templates.md) for a minimal starting point.
Preserve user content and existing metadata. Assign one writer to shared notes;
use targeted edits after a fresh read. If using the Obsidian tools, follow their
read-before-overwrite and confirmation requirements; append dated logs rather
than replacing them. Scope searches to the actual notes subtree, not a workspace
containing repositories, worktrees, caches or archived transcripts. Plain Markdown
and exact filesystem paths work without Obsidian or any community plugin.

## Keep state and evidence separate

Use `inbox`, `ready`, `implementing`, `validating`, `review`, `done`, `parked`,
`cancelled`, or `unknown` for a new work item's stage. A blocker is a separate
fact: record why work is blocked without discarding the current stage. Do not
silently convert existing schemas or infer completion from historical prose.

Keep implementation progress, pull-request publication, deployment, and local/CI
verification separate. Record the revision, actual observation date/time and source
for remote status. Old green CI does not verify a newer head. Do not invent IDs,
owners, approval, dates, or tracker metadata. Dependencies should say whether they
concern implementation, merge order, deployment, or shared verification.

## Checkpoint and hand off

At a meaningful milestone, before compaction, or before a user-requested session
replacement, update the existing notes with the current goal and scope, decisions,
exact checkout/branch, changed files, checks and results, unresolved issues, next
action, and what still requires permission. Keep raw logs separate and link them.

Give a new lead exact absolute paths to the Overview, relevant Context/Todos and
assigned delivery, plus a short goal and authority boundary. Files do not load
merely because they share a folder. The new lead reads them and verifies checkout
state before acting; it asks about contradictions rather than inventing missing
context. A checkpoint does not authorize restarting sessions, moving worktrees,
resuming child writers, publishing, or reusing historical approvals.
