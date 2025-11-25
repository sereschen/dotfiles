---
description: Generate a nice commit message from staged changes
agent: general
---

Please analyze the staged git changes and generate a professional, well-structured commit message following conventional commits format.

Here are the staged changes:
!`git diff --cached`

Generate a commit message that:
1. Follows conventional commits format (type: scope: description)
2. Provides a concise, descriptive summary (50 chars or less)
3. If needed, includes a body with detailed explanation
4. Uses imperative mood ("add" not "added")
5. Is clear and explains the "why" not just the "what"

Suggest the complete commit message I can use with `git commit -m "..."` or `git commit` for a multi-line message.
