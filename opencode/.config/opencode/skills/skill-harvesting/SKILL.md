---
name: skill-harvesting
description: >-
  Turn corrections and lessons from the current session into candidate skills.
  Use ONLY when the user explicitly asks to harvest, capture, or "turn this into
  a skill" — reflecting on the session's mistakes, corrections, and conventions
  and proposing new skills or updates to existing ones. Writes candidate files
  for review; never creates or edits real skills without explicit approval.
disable-model-invocation: true
---

# Skill Harvesting

Reflect on a finished piece of work and propose what should become a reusable
skill — a new one, or an update to an existing one. The unit of value is a
correction the agent would otherwise repeat: a mistake the user fixed, a
convention they stated, an insight that changes how similar work should be done.

## When to run

Run only when the user asks — at the end of a session, after a review, or when
they say "capture this." This is a deliberate reflection step, not a background
watcher.

## Process

### 1. Gather the session's corrections

Read back over the current session for the raw material:

- Mistakes the user corrected (they rejected an approach, fixed output, said
  "no, do it this way").
- Conventions the user stated as general rules, not one-off preferences.
- Insights that changed the approach mid-task.
- Repeated legwork — if the same helper, command, or multi-step dance recurred,
  that recurrence is itself a candidate.

Distinguish a **rule** from a **one-off**: a rule would apply again on the next
similar task; a one-off was true only for this file, this ticket, this moment.
Only rules are candidates.

### 2. Apply the reuse bar

A candidate must clear two tests before it earns a place:

- **Recurrence** — would this fire again on future work, or was it situational?
- **Non-default** — does it change behavior versus what the model already does?
  A rule the model already follows by default is a no-op; capturing it spends
  load to say nothing. If you are unsure, the honest signal is observation: has
  the mistake actually shown up? A stated-but-never-violated preference is
  weaker than a twice-observed correction.

Finding nothing is a valid, common outcome. Never invent candidates to look
productive.

### 3. Decide the home for each candidate

For each surviving candidate, decide where the correction should live. This is
the load decision, not a formality:

- **Always-relevant → the always-loaded rules file** (`AGENTS.md`). Applies on
  nearly every turn, has no clean gating branch (e.g. a naming convention, a
  language-wide style rule). A branch-gated skill would load it only sometimes,
  which for an always-relevant rule is worse.
- **Branch-triggered → a skill.** Fires only in a recognizable case (writing
  tests, doing a refactor, touching one framework). Name the branch — that
  branch becomes the skill's description trigger.
- **Update vs. new** — prefer extending an existing skill over creating an
  overlapping one. If an existing skill already covers the area, the candidate
  is an edit to it, not a sibling beside it.

Phrase every proposed rule the way it will actually be written: state the target
behavior positively (name the tool, the pattern), give the *why*, and reach for
a concrete word over a vague one. A prohibition earns its place only as a hard
guardrail you cannot phrase positively.

### 4. Present candidates for approval

Show the user an itemized, editable list. For each candidate:

- **Title** — the rule in one line.
- **Type** — new skill, skill update, or `AGENTS.md` rule.
- **Why needed** — the correction/insight it captures and where in the session
  it came from.
- **Proposed home** — the exact file, and the branch that triggers it if a skill.
- **Draft wording** — the actual line(s) as they would be written.

Ask the user to approve, edit, or drop each. Change nothing before they decide.

### 5. Write approved candidates as review files

For each approved candidate, write a candidate file to
`.scratch/skill-candidates/<NN>-<slug>.md` (numbered from `01`), using the
template below. Do **not** edit the real skill or `AGENTS.md` in this step — the
candidate file is the reviewable artifact; applying it is a separate, deliberate
act the user drives.

<candidate-template>

# <NN> — <Rule title>

**Type:** new skill | skill update | AGENTS.md rule

**Proposed home:** the exact target file. For a skill, also its trigger branch.

**Why needed:** the correction/insight this captures, and where in the session
it came from.

**Draft wording:**

> the actual line(s), phrased positively with the why, as they would appear in
> the target file.

**Reuse justification:** why this recurs and why it is non-default (the mistake
was observed, not assumed).

</candidate-template>

### 6. Report

Tell the user what was written: each candidate file and its path, plus any
candidates they declined. If nothing cleared the bar, say so plainly.
