# klf-ai — personal AI repo plan

Goal: one repo owns skills + agents; install/update globally and per-project across
**Copilot CLI and opencode**. Dotfiles keeps only config.

## Why
- `gh skill` (preview) is a cross-tool **skills** package manager (install/update/publish/list/search).
- `.agents/skills/` (project) and `~/.agents/skills/` (user) are read by github-copilot, opencode,
  and ~14 other hosts at once → write once, read everywhere.
- `gh skill` does **not** install agents (skills-only). Embedding agent files inside a skill folder is
  NOT a native agent-discovery path in either tool — the files travel, but neither tool auto-registers
  them as selectable agents. Agents are a separate, per-tool install.
- Personal skills currently live in `~/.config/opencode/skills/` (opencode-only) → Copilot can't see them.

## Agents ARE usable in both tools (verified 2026-08-07)
Both tools have a first-class custom-agent system; the body (prose) is portable, but each needs its own
frontmatter dialect and its own install directory. `gh skill` reaches neither.

| | opencode | Copilot CLI |
|---|---|---|
| Project dir | `.opencode/agents/` | `.github/agents/` (also `.claude/agents/`) |
| Personal dir | `~/.config/opencode/agents/` | `~/.copilot/agents/` |
| Frontmatter | `description`, `mode: subagent`, `model`, `permission` | `name`, `description` (min); + tools/model/reasoning |
| Selected by | Task tool / @-mention | `--agent <name>`, `/agent` picker |

Note: `~/.agents/agents/` is NOT read by Copilot — that home is only for skills (`~/.agents/skills`).
Verified via probe: Copilot loaded agents from `.github/agents/` and `~/.copilot/agents/`, rejected
`~/.agents/agents/`.

## Repo layout
```
klf-ai/
  skills/                      # publishable; name in frontmatter MUST equal dir
    testing/
      SKILL.md
      references/              # refs live INSIDE the skill (install unit = the folder)
    refactoring/SKILL.md
    code-review/SKILL.md
    security-audit/SKILL.md
    pruning/SKILL.md
    skill-harvesting/SKILL.md
    pr-review-author/SKILL.md
  shared-references/           # canonical copies of refs used by >1 skill (NOT published directly)
  opencode-agents/             # NOT skills — kept outside skills/ so publish ignores them
    supervisor.md  implementer.md  planner.md  plan-reviewer.md  runner.md
  copilot-agents/              # same bodies, Copilot frontmatter (name+description)
    supervisor.md  implementer.md  planner.md  plan-reviewer.md  runner.md
  sync-shared-refs.sh          # copy shared-references/* into each dependent skill before publish
  install-agents.sh            # opencode → ~/.config/opencode/agents/, copilot → ~/.copilot/agents/
```

## Workflow
```bash
gh skill publish --dry-run                       # validate frontmatter/naming
gh skill publish --tag v0.1.0                     # release as skills source

gh skill install klf/klf-ai --all --scope user    # → ~/.agents/skills (Copilot + opencode)
gh skill install klf/klf-ai testing --scope project
gh skill install ./klf-ai --all --from-local --scope user   # local iteration
gh skill update --all                             # tree-SHA drift
gh skill install klf/klf-ai testing --pin v0.1.0  # freeze

./install-agents.sh                               # opencode + copilot agents (separate mechanism)
```

## Dotfiles split
- Dotfiles keeps only: `opencode.json`, `tui.json`, `~/.copilot/config.json`.
- `klf-ai` owns skills + agents + references.
- Add `skills/`, `agents/`, `references/` to `~/.config/opencode/.gitignore` (installed content, not source).

## References rule
- The install unit is the **skill folder**: `gh skill install` copies `skills/<name>/` only.
- A skill loads references by path **relative to its own SKILL.md**, so refs must live inside the skill
  (`skills/<name>/references/...`). A top-level `references/` sibling would neither install nor resolve.
- Shared refs (used by >1 skill): keep a canonical copy in `shared-references/` and have
  `sync-shared-refs.sh` copy it into each dependent skill before publish (or just duplicate).

## Tasks
1. Scaffold `klf-ai`; move 7 personal skills + 5 agents in; add `install-agents.sh`.
2. Fix frontmatter (name == dir; description; allowed-tools as string) via `gh skill publish --dry-run`.
3. Publish v0.1.0; install to `~/.agents/skills` for both tools.
4. Dotfiles split + `.gitignore` the installed content.

## Open
- Confirm repo owner/name (`klf/klf-ai`?).
- Decide agent frontmatter strategy: keep separate `opencode-agents/` + `copilot-agents/` copies, or
  generate both from a shared body + per-tool header at install time.
