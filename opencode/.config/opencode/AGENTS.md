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
