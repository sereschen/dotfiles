# Global OpenCode Rules

These are general rules and best practices that apply across all
projects. When initializing a new project without an AGENTS.md file,
copy only the relevant rules based on the project's technology stack.

---

## Package Management

For TypeScript projects, use `pnpm` or `bun` depending on the project
specifications. Check the project files (package.json, lock files, or
documentation) to determine which one is in use. If unsure, ask the
user which package manager they prefer. Avoid using vanilla `npm`
unless explicitly required or specified by the user.

---

## Project Initialization

When there is no AGENTS.md file in a project and you're initializing
the project, copy only the relevant rules from this global file to the
new local AGENTS.md file. Filter rules based on the project's
technology stack and language. For example, only include
TypeScript-related rules if the project is a TypeScript repository;
don't add rules for other languages or frameworks not used in that
project.

---

## Go Projects

For Go projects, suggest or try to add the
[air](https://github.com/air-verse/air) package for hot reloading
during development. This improves the development experience by
automatically recompiling and restarting the application when code
changes are detected.

---

## Docker and Docker Compose

Follow linter warnings and best practices for Docker and Docker
Compose files:

- Use specific image versions instead of `latest` tags to ensure
  reproducibility and avoid unexpected breaking changes
- Specify exact versions for packages installed inside Dockerfiles to
  maintain consistency across builds and deployments
- Use environment variables instead of explicit hardcoded values in
  Docker Compose files for better flexibility across different
  environments (development, staging, production)

---

## React Applications

For React applications, check if TanStack Query (React Query) is
installed in the project. If available, prioritize using `useQuery`
and `useMutation` hooks instead of managing data fetching with
multiple `useState` and `useEffect` hooks. This provides better state
management for server state, automatic caching, synchronization, and
reduces boilerplate code.

---

## Tailwind CSS

If the application uses Tailwind CSS, check the Tailwind linter for
warnings and suggestions. Follow these recommendations to maintain
consistent styling, avoid unused classes, and adhere to Tailwind best
practices.

---

## Documentation

When creating new Markdown summaries or documentation files (such as
change summaries, guides, or reports), place them in an `agents/`
directory at the root of the project, not directly in the project
root. This keeps the root directory clean and organizes documentation
in a dedicated location.

---

## Markdown Linting

When you detect that a project has Markdown files (README.md,
AGENTS.md, CLAUDE.md, or similar documentation files), add a
`.markdownlint.json` or `.markdownlint.yaml` configuration file to
the project root if one doesn't already exist.

Configure markdownlint to disable the `MD013/line-length` rule to
avoid linting warnings. However, even though the rule is disabled, you
should still try to follow the line-length best practice and keep
lines under 80 characters when possible. This ensures readable,
well-formatted documentation without constant warnings.

Example `.markdownlint.json`:

```json
{
  "extends": "default",
  "MD013": false
}
```

Example `.markdownlint.yaml`:

```yaml
extends: default
MD013: false
```

---

## Configuration File Format Preference

When a software tool supports multiple configuration file formats
(e.g., JSON, YAML, TOML), avoid using JSON if possible. Prefer YAML
or TOML instead, as they are more human-readable and maintainable.

Before making this choice:

1. Check the tool's documentation to confirm it supports YAML or TOML
   as valid configuration formats
2. Verify that the tool can properly parse the alternative format
3. Ensure the alternative format can represent all necessary
   configuration options

Only use JSON if the tool doesn't support YAML or TOML, or if there
are specific technical reasons that make JSON necessary for that
particular project.

---

## Code Comments and Documentation

Avoid overusing inline comments in new code. Write code that is
self-explanatory through clear naming and structure. However, for
languages that support documentation comments (such as Go, TypeScript,
and Rust), add proper documentation comments to exported functions,
types, and modules. These documentation comments help tools like
godoc, TSDoc, and rustdoc generate high-quality API documentation.

---

## Development Tools & LSP Integration

When working on projects that use LSP servers, linters, and formatters through tools like
Mason.nvim (Neovim), asdf, or other version managers, OpenCode should:

### LSP Server Awareness

1. **Detect installed LSP servers** - Check system PATH and Mason.nvim installations
2. **Respect LSP diagnostics** - Follow language server warnings and error suggestions
3. **Avoid conflicts** - If multiple LSP servers are available for the same language,
   use the one specified in the project configuration

### Popular LSP Servers

**By Language:**

- **Lua** - `lua_ls` (Lua language server)
- **Bash/Shell** - `bashls` (Bash language server)
- **Go** - `gopls` (Go language server)
- **Python** - `pyright` (Python language server)
- **Rust** - `rust_analyzer` (Rust analyzer)
- **TypeScript/JavaScript** - `typescript` (TS language server)
- **JSON** - Built-in JSON schema validation
- **YAML** - `yaml-language-server`

### Code Quality Tools

**Linters** (tools to check code quality):

- **Shell scripts** - `shellcheck` (detects common shell script errors)
- **Python** - `pylint`, `flake8`
- **Go** - `golangci-lint`
- **Rust** - `clippy`
- **JavaScript/TypeScript** - `eslint`

**Formatters** (tools to format code):

- **Shell scripts** - `shfmt` (shell script formatter)
- **Lua** - `stylua` (Lua code formatter)
- **Python** - `black`, `autopep8`
- **Go** - `gofmt` (Go formatter)
- **Rust** - `rustfmt` (Rust formatter)
- **JavaScript/JSON** - `prettier` (prettier code formatter)
- **YAML/Markdown** - `prettier` (if available)

### Guidelines for OpenCode

1. **Automatic Formatting** - Apply formatters after writing/editing files to maintain
   consistent code style across the project

2. **Diagnostic Feedback** - When LSP servers report warnings or errors:
   - Include them in your context when making suggestions
   - Suggest fixes that resolve LSP diagnostics
   - Only suppress warnings when there's a valid reason (document why)

3. **Tool Discovery** - Try to find tools in this order:
   - System PATH (installed via package managers like Homebrew, apt, pacman)
   - Mason.nvim installations (Neovim plugin manager for LSP/formatters)
   - Local project installations (node_modules, venv, etc.)
   - Built-in tools (gopls, rust-analyzer via rustup, etc.)

4. **Language-Specific Best Practices**
   - **Shell scripts**: Follow ShellCheck recommendations, use `[[` over `[`, quote variables
   - **Lua**: Follow LazyVim conventions, avoid inline comments in configs
   - **Python**: Follow PEP 8 standards with black formatter
   - **Go**: Follow Go conventions, consider air for development with hot reload
   - **Rust**: Follow Rust API guidelines, use clippy suggestions
   - **TypeScript**: Use strict mode, add proper documentation comments

5. **When Tools Aren't Available** - If a required formatter or LSP isn't found:
   - Check if the tool needs to be installed
   - Suggest installation method (Homebrew, Mason, npm, etc.)
   - Continue with best practices even if tool isn't available

### Configuration Management

LSP servers and formatters are typically configured via:

- **opencode.json** - Project-specific LSP/formatter configuration
- **AGENTS.md** - Project rules and guidelines
- **Tool config files** - `.stylua.toml`, `.prettierrc`, `golangci.yml`, etc.

When multiple config formats exist, prefer YAML or TOML over JSON for readability.

---

## External Code & Vendored Dependencies

When working with projects that include external code or vendored dependencies, do NOT
modify them and suppress any warnings from these directories:

### Suppress Warnings For

- **@tmux/.config/tmux/plugins/** - All tmux plugin managers and plugins
  (tpm, tmux-sensible, tmux-yank, tmux-resurrect, tmux-continuum, tmux-thumbs,
  vim-tmux-navigator, tmux-fzf, tmux-fzf-url, catppuccin-tmux, tmux-sessionx, tmux-floax)

- **@oh-my-zsh/.oh-my-zsh/plugins/** - All oh-my-zsh plugins and themes
  (asdf, autojump, docker-machine, git-lfs, history-substring-search, kube-ps1,
  and all other vendored plugins)

### Guidelines

1. **Do NOT modify** - External code should be left untouched
2. **Do NOT fix warnings** - Let the original maintainers handle issues
3. **Suppress all warnings** - Use linter/formatter directives if needed to silence them
4. **Document why** - If you must reference external code, explain it's external
5. **Keep in sync** - Only update these when explicitly needed (version bumps, security fixes)

### Examples

If you encounter warnings from these directories:

- Ignore shellcheck warnings from tmux plugins
- Ignore any linter warnings from oh-my-zsh plugins
- Skip formatting suggestions for external code
- Focus modifications only on YOUR code, not external dependencies
