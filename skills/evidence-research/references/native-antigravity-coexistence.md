# Native Antigravity and Cross-Skill Coexistence

Read this reference before using native parallel research, persisting a packet, or handing evidence to another core skill.

## Stable native responsibilities

### Skills and triggering

Antigravity discovers skills from their names and descriptions, then loads the selected `SKILL.md`. The package name is `evidence-research`; explicit Antigravity invocation is `/evidence-research` on surfaces that expose skill slash commands.

Keep the trigger specific to external/current/disputed factual evidence. Do not turn it into a general knowledge or reasoning skill.

### Model and effort

For the target runtime, Antigravity CLI currently documents `gemini-3.8-flash-high` and native low/medium/high effort selection. Model and effort are chosen by the user or host, not by this skill. High effort may support difficult synthesis, but it does not replace current evidence or justify stronger confidence.

### Search, browser, and MCP

Use available search/browser tools to locate and inspect sources. Use MCP when a connected system is the authoritative or live data source. Validate provenance, permissions, result scope, timestamps, and whether a tool read or mutated state.

Tool availability or output does not establish source authority. A generated summary is not a replacement for the underlying source.

### `/plan`

Native planning owns the parent task plan. Evidence Research may decompose a question into atomic claims and evidence needs; it does not create a second project plan.

### `/boost`, Teamwork, and subagents

Use native parallelism only when claims or source families are genuinely independent and the synthesis cost is justified.

Possible partition:

- official documentation and release history;
- source repository or installed/runtime evidence;
- independent research or community contradictions.

Give each worker a bounded claim, date/version/scope target, source-family mandate, and evidence-record output. Keep one synthesis owner. Do not ask several agents to search the same web generally, vote on truth, or use agent count as confidence.

For high-consequence or strongly conflicting questions, one fresh-context pass can examine a different source family or attempt to falsify the working conclusion. Do not feed it the desired answer. Another pass requires new information value.

### Rules, hooks, permissions, and artifacts

- Rules hold persistent constraints, not the research workflow.
- Hooks can record/enforce deterministic tool policy, not decide epistemic truth.
- Permissions govern tool and external actions; research never bypasses them.
- Artifacts can carry a reusable evidence packet when the parent workflow needs one. They are not a new memory system.

Availability and exact behavior can vary by Antigravity surface, OS, plan, version, and rollout. Use capability-based instructions and report unavailable mechanisms rather than hardcoding private internals.

## Core-skill boundaries

### Perfect Code V2

Perfect Code asks a factual question with target version/environment and decision need. Evidence Research returns the compact packet. It does not inspect broadly for engineering defects, modify files, choose the implementation, or claim engineering completion.

### Risk & Change Assurance

Evidence Research supplies current factual inputs, unresolved conflicts, and conditional implications. Risk owns consequence, control, rollback, mitigation, and state-transition gates; the applicable owner or authority owns authorization. Evidence Research leaves an unresolved critical fact `UNRESOLVED` and does not preselect a block, condition, or control. Risk independently decides how that evidence affects its gate. A later Risk decision is preserved by provenance pointer and does not rewrite the evidence conclusion.

### Continuity & Recovery

Evidence Research owns provenance and refresh. Continuity records the accepted claim pointer and task impact, then requests refresh when validity conditions change. Neither copies the other’s full state.

## Graceful degradation

- Without browser/search/MCP, use user-provided, local, cached, or installed evidence with dates and provenance.
- If current evidence is necessary and unavailable, return `BLOCKED`.
- Without subagents, run the same claim/source workflow serially.
- Without another core skill, produce standalone research and state the unowned downstream decision boundary.
- Never invent missing tool results, source contents, or another skill’s decision.

## Composition invariants

- One research synthesis owner.
- One owner per material claim.
- One provenance trail per claim; references point to it instead of copying it.
- A partner reuses the owned packet while its validity conditions hold; it does not silently re-research or overwrite the conclusion.
- Later, more applicable evidence supersedes stale evidence only through an explicit claim update and reconciliation with the canonical task state.
- Source disagreement is resolved by evidence and applicability, not agent vote.
- Evidence conclusions and Risk gates remain separate owned states; neither silently overwrites the other.
- Continuity owns the one canonical task state and current verified repository/system state; Evidence Research supplies claim status and validity, not a competing ledger.
- `RESEARCH = COMPLETE` is independent of engineering, continuity, consequential-gate, and overall task status. The parent workflow retains its own completion and authorization status.
