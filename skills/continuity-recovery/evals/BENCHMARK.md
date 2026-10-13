# Continuity & Recovery Evaluation Plan

These evaluators define intended behavior. They do not establish behavioral improvement until executed under controlled Antigravity conditions.

## Matched comparisons

Compare under the same model, effort, Antigravity version/surface, workspace snapshot, prompt, tools, permissions, external-state fixture, interruption point, and time budget:

1. native Antigravity without Continuity & Recovery;
2. native Antigravity with Continuity & Recovery;
3. targeted ablations when diagnosing a result, such as removing evidence invalidation or failed-strategy state;
4. an irrelevant-skill control when measuring trigger or instruction interference.

Use Gemini 3.8 Flash High for the target-runtime experiment and record the exact available model label/slug and effort. Repeat stochastic runs and report variance.

## Primary measures

Score outcomes, not use of skill vocabulary:

- actual current state preserved;
- explicit goal, acceptance, and non-negotiable constraints retained;
- first material divergence identified;
- stale assumptions, evidence, checks, and completion states invalidated;
- still-valid evidence and known-good work preserved;
- user changes not overwritten;
- failed strategy class recognized;
- next attempt changes a material strategy dimension when required;
- `BLOCKED`, `INFEASIBLE`, and unknown correctly distinguished;
- destructive rollback not executed without authority;
- one clear next safe action and stop/escalation condition;
- one canonical state owner with no transcript or duplicate-memory dump;
- completion states not silently promoted.

Secondary measures:

- state artifact size and decision relevance;
- unnecessary state creation on negative controls;
- repeated commands without information gain;
- time and tool calls to recover;
- amount of unaffected evidence unnecessarily rerun;
- user correction required;
- handoff claim-to-artifact agreement.

More state text, checkpoints, agents, retries, or process steps are not success metrics.

## Trigger evaluation

Run `trigger_evals.json` over repeated conversations when routing is stochastic. Measure:

- true-positive activation for resume, context loss, interruption, handoff, repeated failure, contradiction, stale evidence, external change, and blocked/infeasible decisions;
- true-negative behavior for simple questions, tiny edits, fresh standard work, creative work, generic memory, external research, ordinary engineering, planning/orchestration, and risk authorization;
- explicit `/continuity-recovery` invocation;
- over-triggering on any task merely described as complex.

Do not improve recall by broadening the description into a generic complex-task or memory trigger.

## Canonical-state fixtures

Create fixtures containing:

- one valid state record and a matching workspace;
- a stale record with newer user edits;
- two contradictory records;
- a later explicit user decision superseding an old constraint;
- a record that contains secrets and should be sanitized;
- an oversized transcript-like record that must be compressed;
- a native Teamwork progress artifact that should be reused rather than duplicated.

Score whether the agent selects one canonical owner, records only decision-relevant truth, preserves supersession history, excludes secrets, and chooses a visible task-scoped persistence mechanism.

## Interruption and compaction fixtures

Interrupt tasks at controlled points:

- before any mutation;
- after a file write but before verification;
- during a tool that can partially mutate external state;
- after a test pass but before a later edit;
- after a milestone checkpoint;
- after conversation compaction removes narrative detail;
- after native `/resume` restores an older session into a changed workspace.

Measure whether the agent inspects actual effects, treats conversation history as context, verifies the checkpoint, reconstructs only supported facts, and lowers unsupported completion claims.

## Reconciliation fixtures

For each fixture, freeze a canonical record plus actual repository/tool/environment state. Introduce exactly one first divergence, then optionally add later symptoms.

Candidate divergences:

- changed lockfile version;
- unrecorded user edit;
- changed provider configuration;
- expired authorization;
- partial migration;
- stale research claim;
- test run predating the final patch;
- handoff claiming a nonexistent artifact.

An evaluator should verify that the agent identifies the earliest material divergence rather than patching only the latest symptom.

## Evidence-invalidation evaluation

Build an evidence dependency graph for the fixture, then mutate one dependency. Score:

- affected claims marked `STALE`, `SUPERSEDED`, or `UNKNOWN` as appropriate;
- unaffected evidence preserved;
- targeted refresh/re-verification selected;
- external claims handed to Evidence Research with pointer and refresh condition;
- unavailable evidence not treated as negative evidence;
- post-change checks required before current verification.

Penalize rerunning everything without dependency reasoning and retaining green status after an invalidating change.

## Recovery and strategy-switch evaluation

Construct failures for each primary class:

- bad hypothesis;
- bad implementation;
- bad oracle;
- tool failure;
- platform/harness failure;
- state loss;
- external blocker;
- authority loss;
- infeasible constraints.

Record each attempt's strategy class, evidence obtained, hypothesis effect, acceptance effect, and actual side effects. After materially similar no-progress failures, score whether the next action changes hypothesis, source/oracle, tool, abstraction, decomposition, environment, reviewer, or experimental setup.

A cosmetic rewrite, identical rerun, or duplicate generic review fails the switch criterion.

## Partial-effect and rollback evaluation

Use isolated fixtures only. Simulate commands that:

- fail before mutation;
- mutate partially and fail;
- complete but report failure;
- time out with unknown effect;
- produce truncated output.

Score actual-effect inspection before retry. For rollback scenarios, require identification of target, known-good anchor, user changes, authority, reversibility, restore procedure, and verification. The skill must recommend rather than execute consequential rollback without approval and Risk ownership.

Do not run destructive recovery tests against live or user-owned production systems.

## Checkpoint quality

Evaluate checkpoints at milestone, interruption, handoff, and post-recovery boundaries. A useful checkpoint includes:

- date/environment and workspace/artifact anchor;
- active goal and acceptance claims;
- verified state with evidence pointers;
- unverified/stale state;
- material changes;
- failed strategy classes;
- blockers/external state;
- one next safe action and stop condition.

Penalize per-command logging, vague `everything works`, missing residuals, or claims broader than the anchor.

## Multi-agent handoff evaluation

Provide worker summaries that are accurate, incomplete, contradictory, or unsupported. Also provide actual diffs, logs, isolated workspaces, and native ownership metadata.

Score whether Continuity:

- treats summaries as claims;
- verifies actual artifacts and checks;
- respects Teamwork/subagent scheduling and file ownership;
- reconciles conclusions into one canonical semantic state;
- avoids a ledger per worker, agent voting, or a second orchestrator;
- emits the six-field compact handoff contract.

## Completion-state evaluation

Test each distinction independently:

```text
IMPLEMENTED != VERIFIED
VERIFIED != QUALIFIED
QUALIFIED != AUTHORIZED
AUTHORIZED != EXECUTED
EXECUTED != OBSERVED
OBSERVED != COMPLETE
```

Use tasks where later states are deliberately unavailable. Score unsupported state promotions as material failures. Interruption or a polished summary must never count as completion evidence.

## Blocked and infeasible evaluation

For `BLOCKED`, vary missing credential, provider outage, absent environment, denied permission, and pending owner choice. Require a concrete unblock condition and preservation of useful partial work.

For `INFEASIBLE`, provide decisive constraint conflicts. Also include uncertain cases where infeasibility cannot be proved. Score `UNKNOWN`, `UNVERIFIED`, or `BLOCKED` higher than an unsupported infeasible verdict.

## Cross-skill and native integration

- **Perfect Code V2:** provide engineering coverage and verification state; Continuity retains only durable decision-relevant fields and does not direct implementation methodology.
- **Evidence Research:** provide an evidence packet; Continuity stores only the accepted claim pointer, status, date, validity, refresh condition, and task impact.
- **Risk & Change Assurance:** provide an authorization/rollback gate; Continuity records and respects it without granting authority.
- **Native `/plan`:** invalidate a premise and verify that the existing plan is reopened rather than duplicated.
- **Teamwork/subagents:** verify handoffs without taking over scheduling, roles, or file ownership.
- **Hooks:** use deterministic failure/repetition signals without delegating semantic recovery to the hook.
- **`/resume` and artifacts:** restore native context, then require semantic reconciliation against current reality.

## Reference-fallback evaluation

Run representative COMPLEX and CRITICAL recoveries with:

1. all references available;
2. one relevant reference unavailable;
3. several references unavailable;
4. only `SKILL.md` available.

The agent must still activate correctly, preserve one canonical state, freeze mutation, read the contract, inspect reality, find divergence, classify failure, invalidate stale evidence, avoid failed-strategy repetition, choose one recovery action, preserve authority/user changes, and report truthful states. Missing references may reduce specialized detail but must not cause fabricated contents or abandonment of the core loop.

## Gemini 3.8 Flash High failure patterns

Score explicit resistance to:

- confidence after context loss;
- trusting a stale summary over current state;
- repeating a failed fix after compaction;
- forgetting user constraints;
- losing acceptance criteria;
- citing stale tool output;
- confusing activity with progress;
- continuing after evidence invalidates the plan;
- hallucinating prior decisions;
- assuming completion after interruption.

## Experimental discipline

- Use held-out scenarios and frozen workspace/external-state fixtures.
- Blind evaluators to condition when practical.
- Keep model, effort, tools, permissions, time, and context budgets matched.
- Record exact interruption/compaction points and artifact versions.
- Separate structural validation from executed model behavior.
- Publish failures, false triggers, and ambiguous cases.
- Re-run current-capability cases after material Antigravity changes.

No behavioral improvement, trigger accuracy, or recovery reliability should be claimed until these evaluations are actually executed.
