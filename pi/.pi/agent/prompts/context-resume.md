---
description: Continue from durable task notes without replaying a previous session
argument-hint: "<Overview path>"
---
Load the work-context skill and read the work item at $1. If no unambiguous path
was supplied, ask for it. Read relevant parent/current decisions and the next
action, verify the actual repository, checkout, branch and local changes, and
summarize the approved scope and any contradictions. Continue only actions
authorized by the current request and applicable instructions; do not treat
historical approvals, a merged PR or an old passing check as current authority
or completion evidence. Do not start another session or replay old transcripts.
