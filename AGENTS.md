# Dotfiles Repository Instructions

## Repository layout

- Top-level tool directories are GNU Stow packages. Their hidden paths mirror the
  destination under `$HOME`, for example `tmux/.config/tmux/tmux.conf`.
- Neovim configuration lives in `lazyvim/`, not `nvim/`.
- `Brewfile` lists Homebrew dependencies. `setup.sh` installs them and stows `zsh`,
  `tmux`, and `lazyvim`. Other packages are stowed separately.
- Read the relevant package configuration and README before making changes.

## Change scope and safety

- Inspect staged, unstaged, and untracked changes before editing. Preserve existing
  work and do not include unrelated changes in commits.
- Configuration files may already be symlinked into the live environment. Editing
  them can affect the next application launch or shell immediately.
- Keep changes focused and match the package's existing conventions. Update its
  documentation when dependencies, bindings, or behavior change.
- Do not run installers, install or update dependencies, restow packages, or reload
  live applications unless the task calls for it. Prefer dry runs and isolated
  validation over disrupting active shells or tmux sessions.
- Do not modify or commit downloaded plugin repositories, generated caches, local
  overrides, credentials, or secrets as incidental cleanup.
- Use TypeScript for new maintained scripts, and Bash for small command wrappers.
  Preserve the language of existing scripts unless a rewrite is requested.

## Portability

- Keep this repository machine-agnostic so an agent can help set it up on another
  Mac or Linux machine with minimal manual changes.
- Use paths relative to the configuration, repository, or working directory when
  the application resolves them reliably. For user-specific paths, prefer `$HOME`,
  XDG variables, and the application's supported environment-variable syntax.
  Do not assume every configuration format expands shell variables or `~`.
- Discover executables through `PATH` or the package manager's reported prefix.
  Avoid hardcoded usernames, home directories, `/opt/homebrew`, or `/usr/local`
  when a portable alternative is available.
- Detect macOS/Linux differences and required capabilities instead of assuming
  one OS, CPU architecture, shell version, or package-manager layout. Isolate
  unavoidable platform-specific settings and document their requirements.
- Put machine-specific paths and secrets in documented environment variables or
  gitignored local overrides. Provide portable defaults where possible.
- When changing a package, check the touched settings for portability. Do not
  silently broaden the task into a repository-wide migration of existing paths.
- Document any remaining manual setup and state which platforms were actually
  verified; do not claim Linux compatibility based only on checks on macOS.

## Verification

- Use focused checks appropriate to the changed package. There is no repository-wide
  test runner; do not invent one or run the installation scripts as a test.
- For shell scripts, use the matching syntax checker (`bash -n` or `zsh -n`).
- For tmux configuration, use `source-file -n` to parse without executing commands.
  If runtime validation is needed, use a separate tmux socket and stop only that
  disposable server afterward. Never stop the user's active server.
- Use available language-server diagnostics for supported files, and report when
  they are unavailable. Run `git diff --check` on the changes being committed.
- Complete the configured independent review before committing. Do not bypass
  failing checks or a failed review. Report what could not be verified.

## Commits

- Commit every completed, verified change made for the current task automatically.
  Do not ask for approval of the file selection, commit message, or `git commit`
  command. This repository rule overrides generic commit-confirmation defaults.
- Use one commit per Stow package by default. Combine multiple packages when they
  implement one related change, such as a wrapper and its shell PATH integration.
  Keep unrelated changes separate even when made during the same session.
- Include related documentation and shared dependency changes in the corresponding
  package commit. Put repository-wide instructions in a separate repository commit.
- Stage explicit paths or individual hunks. Never use `git add .` or `git add -A`
  to sweep in pre-existing work. Ask only when ownership or scope is genuinely unclear.
- Use conventional commit subjects such as `fix(tmux): restore popup theme colors`
  or `chore(repo): document repository workflow`. Add the standard
  `Co-authored-by: Codex <noreply@openai.com>` trailer when Codex authors the change;
  other agents should use their own attribution.
- Automatic commits do not authorize pushing, opening PRs, merging, amending existing
  commits, or destructive Git operations. Obtain the applicable authorization first.
- Finish by reporting the commits, verification results, and any changes left
  uncommitted. Do not claim the working tree is clean without checking it.
