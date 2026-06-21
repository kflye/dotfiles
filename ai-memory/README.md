# ai-memory

Local learned-memory CLI for development agents.

`ai-memory` stores durable project learnings in Markdown and indexes them with SQLite FTS. It is intentionally separate from Graphify. Use Graphify by itself for structural codebase memory.

## Commands

- `ai-memory init`
- `ai-memory refresh`
- `ai-memory search "<query>"`
- `ai-memory recall "<task>"`
- `ai-memory note`
- `ai-memory status`
- `ai-memory opencode install`
- `ai-memory opencode status`
- `ai-memory opencode uninstall`

Markdown under `.ai-memory/` is the source of truth. SQLite is an index/cache and can be rebuilt with `ai-memory refresh`.

## Scope

Use `ai-memory` for learned project memory:

- gotchas
- verified commands
- decisions
- debug-session lessons
- feature status
- module notes

Use Graphify separately for structural codebase memory:

- file/module relationships
- architecture questions
- impact analysis
- graph/path/explain queries

Recommended Graphify setup, if desired:

```sh
graphify opencode install
graphify copilot install
graphify update .
graphify hook install
```

## OpenCode

Install the OpenCode AGENTS reminder in the current repo:

```sh
ai-memory opencode install
```

Check installation status:

```sh
ai-memory opencode status
```

Remove the managed repo-local OpenCode integration:

```sh
ai-memory opencode uninstall
```

Run this per repo, like `graphify opencode install`. Restart OpenCode after installing or uninstalling so config-time files are reloaded.

## Notes

Create a durable memory note:

```sh
ai-memory note --kind gotcha --title "Migration env var" --path packages/db --summary "Migrations require DATABASE_URL."
```

List templates:

```sh
ai-memory note --list-templates
```

Render a template without writing it:

```sh
ai-memory note --kind debug-session --title "Flaky test investigation" --template
```

Refresh the SQLite index after manual Markdown edits:

```sh
ai-memory refresh
```

`refresh` also regenerates:

- `.ai-memory/indexes/project-map.md`
- `.ai-memory/indexes/file-index.md`
- `.ai-memory/indexes/stale-paths.md`
- `.ai-memory/indexes/agent-instructions.md`

`stale-paths.md` reports memory notes whose affected paths no longer exist.
