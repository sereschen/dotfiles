# Work note templates

Use these only within an agreed notes location. Replace placeholders with observed
facts, omit unknown optional fields, and preserve existing schemas. Supporting
notes are optional; the Overview is the canonical entry point.

## Overview.md

```markdown
---
type: work-item
id: LOCAL-0001
title: Short work title
stage: ready
blocked: false
---

# Short work title

## Goal and acceptance

What must be true, and how will it be checked?

## Approved scope

What is included and excluded? Which actions still need approval?

## Current state

Exact repository, checkout, branch, relevant revision, and current changes.

## Blockers and next action

What prevents progress, and what should the next lead do first?

## Related context

Link current decisions, checklist, delivery records and evidence when they exist.
```

## Todos.md

```markdown
# Questions and actions

## Open questions

- [ ] Resolve the outstanding scope question with the user.

## Approved work

- [ ] Implement the agreed change.
- [ ] Verify the acceptance criteria and link evidence from History or delivery.
```

## Context.md

```markdown
# Current decisions and contracts

## Approved decisions

Record the current decision, its reason and its source.

## Constraints and contracts

Record relevant interfaces, exclusions and compatibility requirements.

## Sources and open uncertainties

Link exact files or source URLs. Distinguish observed facts from proposals.
```

## History.md

```markdown
# History

## Actual checkpoint date/time

- Goal and scope at this checkpoint:
- Checkout, branch and revision:
- Changed files:
- Checks and results:
- Decisions, blockers and next action:
- Remaining approval boundary:
```

## deliveries/change.md

```markdown
# Change delivery

## Identity and scope

Parent work item, repository, checkout, branch and exact revision.

## Publication and deployment

Record only observed pull-request/base/deployment facts, with source and timestamp.

## Verification

Separate local checks from remote CI. Record the revision each result covers.

## Dependencies

Distinguish implementation, merge, deployment and shared-verification dependencies.

## Next action and authority

What remains, and what requires the user's decision?
```
