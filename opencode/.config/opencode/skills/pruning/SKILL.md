---
name: pruning
description: >-
  Notice and report inconsistencies across the skill set — broken cross-references
  to skills or files that do not exist, contradictions between skills, duplicated or
  drifted guidance, and stale pointers. Use continuously in the background while
  reading or following any skill (report inline), or when the user asks for a full
  audit of the skill set (report as candidate files). Flag only — never fix, edit,
  or remove anything unless the user explicitly instructs it.
---

# Pruning

Notice and **report** problems in the skill set — nothing more. When an
inconsistency or a reference to something that does not exist crosses your path,
flag it to the user and let them decide. This is how the skill set is kept from
accumulating stale sediment: the guidance no one dares remove because adding
felt safe and removing felt risky.

## Two modes

**Incidental (the default).** While you read, load, or follow a skill for other
work, notice problems as they cross your path and flag them inline. You do not
stop your task to hunt — but you do not silently pass over a problem either. A
trivial stale pointer is a one-line inline flag, resolved in the same breath;
do not persist it anywhere.

**Audit (on request).** When the user asks for a full sweep of the skill set,
the work is wide and disposable — many independent skills to read, and only the
distilled findings matter. This is a strong case for subagents:

- Launch `explore`/`task` subagents in parallel, each responsible for a slice
  of the skill set, instructed to read those skills and return only the
  problems they find — with locations and quoted evidence.
- Give each subagent the full flag-only constraint: it reports, it does not fix.
- Aggregate every finding into one itemized report, and write it as candidate
  files (see *Audit output*) so a batch of findings does not evaporate.

A sweep is judged on completeness: every problem of the five kinds below,
surfaced with its location and quoted evidence — none passed over silently.

## Flag-only — never remedy

Strictly observe and report: name the problem, explain it, and stop — the only
change you ever make to a skill is one the user explicitly instructs. Filing a
finding as a candidate file *is* flagging, not fixing, so it stays within this
rule; editing, deleting, creating, or repointing a skill does not, and waits for
that instruction.

## What to flag

1. **References to skills that do not exist** — a skill points to another by
   name that is not in the set: never created, renamed (pointer uses the old
   name), or moved (pointer describes a location that no longer matches).
2. **References to missing files or assets** — a sibling document, reference
   path, or bundled file that cannot be found or is misnamed.
3. **Contradictions between skills** — two skills give conflicting instructions
   for the same situation, or a skill contradicts itself.
4. **Duplication and drift** — the same guidance maintained in two places, the
   copies diverged, and it is unclear which is authoritative. Common after
   content is extracted into a new skill but an old copy remains.
5. **Stale or dangling instructions** — a step referring to a renamed field, a
   removed section, or a checklist item pointing at deleted content.

## How to report

Give the user enough to act without hunting:

- **What** the problem is (missing reference, contradiction, duplication, etc.).
- **Where** — the skill name and the specific line, section, or quoted phrase.
- **The conflicting sides**, for contradictions or duplication — quote both.
- **A suggested resolution**, clearly marked as a suggestion the user must
  confirm (e.g. "the pointer likely should be `helm-config-validation`").

Then stop and wait. Do not batch a fix in with the report. Collect multiple
incidental findings into a single itemized list rather than interrupting
repeatedly.

## Audit output

For an audit sweep, write the aggregated findings to
`.scratch/pruning-findings/<NN>-<slug>.md` (numbered from `01`), one file per
finding, so a batch is not lost. Each file carries: what, where (with quoted
evidence), the conflicting sides, and a clearly-labelled suggested resolution.
Then report the list and its paths to the user, and stop. Incidental findings
during other work stay inline — do not write files for them.
