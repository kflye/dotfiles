# Local Repo Memory System Plan

## Goal

Build a local-only, per-repo memory system for development agents that reduces repeated codebase exploration and captures durable project learnings over time.

The system must work without MCP servers and must be usable by OpenCode and GitHub Copilot CLI through ordinary files and CLI commands.

This plan now separates two concerns:

- Graphify is used as-is for structural codebase memory, installed and managed through Graphify's own OpenCode/Copilot installers and hooks.
- `ai-memory` is a smaller learned-memory layer for project gotchas, commands, decisions, debug-session lessons, and feature/module notes.

## Core Decisions

- Markdown is the source of truth.
- SQLite is an index, cache, and search layer that can always be rebuilt from Markdown.
- Graphify is a separate optional companion for structural codebase memory.
- Memory lives per repo under `.ai-memory/`.
- `.ai-memory/` will be ignored by the user globally, not managed by this tool initially.
- The reusable implementation should live in this dotfiles repo.
- Python is preferred over TypeScript unless later constraints change, because SQLite, Markdown parsing, and optional local retrieval tooling fit Python well.
- Agent instruction files are managed separately by the user. The system should provide snippets and commands, not generate Copilot instruction files automatically.
- `ai-memory` should not install, wrap, or manage Graphify. Graphify owns its own lifecycle.

## Memory Layers

### 1. Structural Memory

Provided by Graphify when installed and run separately.

Purpose:

- Map repo structure.
- Identify relevant files and modules.
- Reduce broad grep/list/read exploration.
- Help agents answer where to look first.
- Provide a repo-level graph that can be refreshed when code changes.

Stored by Graphify under:

```text
graphify-out/
```

Expected files:

```text
graph.json
GRAPH_REPORT.md
graph.html
```

### 2. Durable Project Memory

Provided by Markdown files, indexed by SQLite.

Purpose:

- Capture gotchas.
- Capture verified commands.
- Capture architectural decisions.
- Capture debugging discoveries.
- Capture feature lifecycle.
- Capture unstructured agent learnings.
- Preserve removed/deprecated feature knowledge.

Stored under:

```text
.ai-memory/markdown/
.ai-memory/sessions/
.ai-memory/memory.db
```

Markdown remains authoritative. SQLite can always be deleted and rebuilt.

## Proposed Per-Repo Layout

```text
.ai-memory/
  README.md
  memory.db
  markdown/
    commands.md
    gotchas.md
    decisions.md
    observations.md
    feature-status.md
    module-notes.md
  sessions/
    YYYY-MM-DD-topic.md
  indexes/
    project-map.md
    file-index.md
```

## CLI

Expose a local command such as:

```text
ai-memory
```

Initial commands:

```text
ai-memory init
ai-memory refresh
ai-memory search "<query>"
ai-memory recall "<task>"
ai-memory note
ai-memory status
ai-memory compact
```

### `ai-memory init`

- Creates the per-repo `.ai-memory/` structure.
- Initializes SQLite schema.
- Creates starter Markdown files if missing.

### `ai-memory refresh`

- Rebuilds or updates SQLite FTS indexes from Markdown.
- Updates generated indexes such as `project-map.md` or `file-index.md`.
- Marks stale memories when referenced paths no longer exist.

### `ai-memory search`

- Searches Markdown memory through SQLite FTS.
- Returns matching notes with paths, kind, status, confidence, and source file.

### `ai-memory recall`

- Combines SQLite memory search and generated indexes.
- Returns concise context for agents before broad exploration.
- Should prioritize paths, commands, gotchas, and recent relevant observations.

### `ai-memory note`

- Adds a Markdown memory note.
- Can be used by agents after substantial work, even if no files changed.
- Should support kinds such as `gotcha`, `decision`, `debug-session`, `command`, `feature`, and `module-note`.

### `ai-memory compact`

- Later feature.
- Deduplicates, merges, or marks stale memory.
- Inspired by Odysseus-style periodic memory consolidation.

## Refresh Workflow

Manual command:

```text
ai-memory refresh
```

`ai-memory note` refreshes the index after writing a note. Run `ai-memory refresh` after manual Markdown edits.

## Agent Behavior

Agents should be instructed:

```text
Before broad exploration:
1. Query repo memory with `ai-memory recall "<task>"` when the command exists.
2. Use returned paths and notes to guide targeted file reads.
3. Avoid broad search unless memory is missing, stale, or insufficient.
4. Verify memory against current files before editing.

After substantial work:
1. Run or rely on `ai-memory refresh`.
2. Add or update memory if durable knowledge was learned.
3. Write memory even if no files changed when a long debugging or investigation session produced reusable knowledge.
4. Do not write memory for trivial edits or obvious facts.
```

## Memory Note Format

Each durable note should include:

```text
title
kind
status
affected_paths
summary
details
verification
confidence
created_at
updated_at
source
last_checked_commit
```

Example kinds:

```text
concept
feature
decision
gotcha
command
bug-pattern
debug-session
module-note
```

Feature statuses:

```text
proposed
active
changed
deprecated
removed
```

When a feature is removed, memory should be marked `removed`, not deleted.

## SQLite Role

SQLite is not the source of truth.

It indexes Markdown for:

- Fast keyword search.
- FTS5 search.
- Metadata filtering.
- Future semantic/vector retrieval if needed.

Suggested tables:

```sql
documents(
  id,
  path,
  kind,
  title,
  status,
  created_at,
  updated_at,
  last_indexed_at,
  last_checked_commit,
  hash
);

document_paths(
  document_id,
  path
);

observations(
  id,
  session_path,
  task,
  summary,
  created_at
);
```

FTS table:

```sql
documents_fts(title, body, path);
```

## Usefulness Metrics

Status: planned for Phase 4. The current implementation has a basic `events` table, but no user-facing metrics commands or usefulness feedback workflow yet.

The system should record local-only usage metrics so it can prove whether it adds value.

Metrics should be stored under:

```text
.ai-memory/metrics/
.ai-memory/memory.db
```

Useful metrics:

- Recall usage: how often `ai-memory recall` is run.
- Recall hit count: how many notes or graph references were returned.
- Recall adoption: whether the agent read files suggested by memory.
- Avoided exploration estimate: number of likely files returned versus number of files actually searched/read.
- Search fallback count: how often the agent still needed broad search after recall.
- Memory write count: how many durable notes were added or updated.
- Stale hit count: how often memory pointed to missing paths or changed files.
- Verification count: how often memory was checked against current files.
- Rejected memory count: how often memory was wrong, irrelevant, or stale.

The goal is not exact token accounting. The goal is to know whether memory changes agent behavior.

Useful derived signals:

```text
recall_usefulness = useful_recalls / total_recalls
stale_rate = stale_hits / total_memory_hits
adoption_rate = suggested_paths_read / suggested_paths_returned
fallback_rate = broad_search_after_recall / total_recalls
```

Healthy signs:

- `recall_usefulness` increases over time.
- `fallback_rate` decreases over time.
- Agents inspect fewer irrelevant files before useful progress.
- Repeated gotchas stop reappearing in sessions.
- Stale hits are low or quickly corrected.

Unhealthy signs:

- Recall returns many notes but agents ignore them.
- Agents still do broad exploration immediately after recall.
- Memory frequently points to deleted or heavily changed files.
- Notes are too vague to guide file reads.
- Memory writes grow quickly but recall usefulness does not improve.

## Usage Log

Status: foundation partially implemented. Basic events are written for refresh, search, recall, and note creation. Phase 4 should make these events actionable.

Record a lightweight event log for observability.

Suggested table:

```sql
events(
  id,
  event_type,
  task,
  query,
  result_count,
  suggested_paths,
  adopted_paths,
  broad_search_after,
  useful,
  stale,
  notes,
  created_at
);
```

Suggested event types:

```text
recall
search
note-created
note-updated
refresh
stale-memory
memory-rejected
verification
```

The CLI should expose summaries:

```text
ai-memory metrics
ai-memory metrics --since 30d
ai-memory metrics --json
```

Useful report sections:

- Top useful memories.
- Top stale memories.
- Recalls followed by broad search.
- Memories with missing affected paths.
- Commands/gotchas used most often.
- Notes never returned by recall.

## Memory Correctness Checks

Status: planned for Phase 4. Phase 3 detects stale affected paths, but does not yet provide reject/useful/verification commands.

Memory is guidance, not authority. The system should include correctness checks.

Automatic checks:

- If a note references paths that no longer exist, mark it stale.
- If referenced paths changed since `last_checked_commit`, lower confidence or mark `needs-verification`.
- If a feature status is `removed`, keep it searchable but never treat it as active.
- If a recall result is contradicted by current files, allow the agent to mark it rejected.

Manual or agent-assisted commands:

```text
ai-memory verify
ai-memory reject <note-id> --reason "stale path"
ai-memory mark-stale <note-id>
ai-memory mark-useful <note-id>
```

Memory note metadata should support:

```text
confidence: high | medium | low
verification_status: verified | needs-verification | stale | rejected
last_checked_commit: <sha>
last_used_at: <timestamp>
use_count: <number>
reject_count: <number>
```

## Baseline Measurement

Before relying on memory broadly, pilot it on one repo and compare a few similar tasks.

Before memory:

- Count files read before useful progress.
- Count broad search commands.
- Note repeated rediscovery of commands, entry points, or gotchas.

After memory:

- Count `ai-memory recall` usage.
- Count files read before useful progress.
- Count broad search commands after recall.
- Track whether suggested files were actually relevant.

The system is valuable if it consistently reduces unnecessary exploration or prevents repeated mistakes without producing noisy or stale guidance.

## Semantic Retrieval

Do not include ChromaDB in V1.

ChromaDB may be added later for unstructured memory retrieval.

Good use cases:

- Long debugging notes.
- Vague recall.
- Similar concepts with different wording.
- Agent-generated observations.

Less useful for:

- Exact commands.
- Feature status.
- File paths.
- Graphify structural data.

Recommended staged approach:

```text
V1: Markdown + SQLite FTS5
V2: Retrieval backend interface
V3: Optional ChromaDB backend with local embeddings
```

If ChromaDB is added, it must remain local-only.

## ChromaDB Considerations

Pros:

- Better fuzzy recall.
- Useful for unstructured session notes.
- Similar to Odysseus memory retrieval patterns.

Cons:

- More moving parts.
- Requires local embeddings.
- Python dependency and runtime complexity.
- Possible irrelevant semantic matches.
- Reindexing needed when model or chunking changes.

## Odysseus Inspiration

Use Odysseus as a design reference, not a direct port.

Reusable ideas:

- Persistent local memory.
- Retrieval over durable facts.
- Deduplication before insert.
- Periodic consolidation.
- Session-derived learning.
- Filesystem-based skills/instructions.

Avoid copying directly because Odysseus is primarily chat/personal memory, not repo-aware code memory.

This system should be repo-aware by tracking:

- paths
- symbols where possible
- commits
- feature status
- stale references
- verification commands

## Initial Implementation Phases

### Phase 1

- Create Python CLI skeleton. Implemented.
- Add `init`, `refresh`, `search`, and `status`. Implemented.
- Create `.ai-memory/` layout. Implemented.
- Create SQLite schema. Implemented.
- Index Markdown with FTS5. Implemented.

### Phase 2

- Add `recall` command for agents. Implemented.
- Add memory note templates. Implemented.
- Add `note` command. Implemented.

### Phase 3

- Add path staleness detection. Implemented.
- Add generated project/file indexes. Implemented.
- Add agent instruction snippet. Implemented.
- Reassess whether generated indexes are still useful now that Graphify is handled externally. Keep for later review.

### Phase 4

- Add compaction/deduplication.
- Add `ai-memory metrics` summaries.
- Add usefulness/correctness feedback commands: `mark-useful`, `reject`, `mark-stale`, and `verify`.
- Use the existing `events` table as the metrics foundation.
- Add optional semantic retrieval interface.
- Evaluate ChromaDB or SQLite vector options.

### Phase 5

- Evaluate Mem0 self-hosted as an optional learned-memory backend once the local repo workflow is stable.
- Keep Graphify separate for structural codebase memory.
- Keep repo-aware behavior in `ai-memory` or a thin wrapper: repo detection, task recall, note kinds, affected paths, status, and agent-friendly output.
- Map repo memory into Mem0 metadata: repo id/path, note kind, affected paths, status, commit, confidence, and verification state.
- Compare Mem0 recall quality, operational friction, local-only setup, exportability, and maintenance cost against SQLite FTS and any Phase 4 semantic backend.
- If Mem0 is adopted, treat it as a pluggable backend rather than the source of all policy. The policy remains the repo-memory workflow and OpenCode skill.
- Require an export/backup path before relying on Mem0 for durable memory.
- Do not make Mem0 mandatory unless it clearly improves recall quality and agent behavior enough to justify the server, LLM, and embedding dependencies.

## Success Criteria

The system is working when:

- Agents query memory before broad exploration.
- Agents inspect fewer irrelevant files.
- Repeated debugging discoveries are captured.
- Memory remains local and gitignored.
- Durable memory can be manually inspected, exported, and backed up.
- Any local index/cache can be deleted and rebuilt without data loss.
