# Canonical State and Storage

Read this reference when a task needs persistent semantic state, after context loss, or before choosing where the state should live.

## One state, not many memories

The state is a compact decision artifact. It should answer:

- What outcome is still being pursued?
- What constraints still govern it?
- What has actually been established?
- Which assumptions and strategies remain live or have failed?
- Which evidence is still valid?
- What is the next safe action and when must work stop?

Do not create separate files for decisions, hypotheses, checkpoints, failures, evidence, or handoffs. Link to source artifacts rather than copying them.

## Field rules

### Goal and acceptance

Preserve the latest explicit user-owned objective and observable success conditions. If later direction changes the goal, record the supersession rather than silently blending incompatible goals.

### Non-negotiable constraints

Keep only constraints that still govern action: scope exclusions, compatibility, security, data preservation, authority, environment, and explicit user limits. Do not promote preferences or guessed intent into constraints.

### Current verified state

State facts with their evidence boundary. Prefer exact statements such as `migration file created; not applied` or `focused test passed on local Windows checkout at commit X` over narrative progress language.

### Decisions

Record only decisions that affect future action. Include rationale, evidence pointer, and `superseded-by` when replaced. Do not erase superseded decisions when their history explains current state.

### Hypotheses

Keep live causal explanations with support, counterevidence, confidence, and a falsifier. Move falsified explanations to invalidated hypotheses; do not quietly reuse them without new evidence.

### Changes and checks

Bind each material change to actual artifact state and each check to result, environment, date, and scope. A command invocation without established result is not a passed check.

### Repository state accounting

Record separate dimensions when repository state affects recovery:

- literal Git state: `CLEAN` or `DIRTY`;
- authorization: authorized, unauthorized, or unknown;
- expectation: expected, unexpected, or unresolved;
- tracking: tracked, untracked, ignored, or outside Git;
- collateral scope: none detected, present, or unverified.

Do not call a repository `clean` when intentional uncommitted changes exist. Say `working tree contains only authorized changes`, `no unauthorized changes detected`, `no collateral changes detected`, or `clean relative to the approved change set` as appropriate; none of those phrases asserts literal Git cleanliness.

### Evidence references

For external research, retain only:

```text
claim | status | provenance pointer | research date | validity scope | refresh condition | task impact
```

The evidence packet remains owned by Evidence Research. For engineering evidence, point to the relevant Perfect Code coverage/check output rather than copying its temporary ledger.

### Failed strategies

Record strategy classes and causal lessons, not every command. A useful entry states what was tried, what failed, the evidence, and what must materially change before a related attempt is justified.

### Checkpoint and next action

The checkpoint describes the latest state known to be valid. `NEXT SAFE ACTION` is one concrete action, not a project plan. `STOP / ESCALATION CONDITION` makes the action bounded.

## Persistence decision

Choose in this order:

1. **Existing native canonical artifact.** If `/plan`, Teamwork, or another active native workflow already maintains one reviewable progress/state artifact that can carry the semantic fields, use or reference it. Do not create a competing ledger.
2. **Existing task artifact location.** If the workspace has an owner-approved convention for task artifacts, use one task-scoped Markdown file there.
3. **Explicit workspace artifact.** For COMPLEX or CRITICAL work without a native or repository convention, choose one visible, clearly task-scoped Markdown artifact after considering repository cleanliness, collaboration, versioning, and owner intent. Record the path in the conversation or handoff.
4. **Response checkpoint.** When persistence is unavailable, inappropriate, read-only, or disproportionate, emit a compact checkpoint in the response and state that cross-session resilience is reduced.

Do not hardcode a universal filename. Do not write into Antigravity's session cache, conversation store, hidden internal directories, or another skill package. Do not commit a state artifact unless normal repository ownership and the task scope justify it.

## State update policy

Update after a decision-changing event, not after every action:

- goal, acceptance, or constraint changes;
- a material hypothesis is strengthened or invalidated;
- a milestone becomes verified;
- evidence becomes stale;
- a strategy class fails;
- a blocker, authority boundary, or external state changes;
- a checkpoint or handoff is created;
- the next safe action changes.

Write the actual timestamp and environment anchor. Avoid vague `recently` or `current` labels.

For composed tasks, this record is also the one place that reconciles the current verified repository/system state and the separate engineering, research, continuity, consequential-gate, and overall-task statuses. It points to each owner's result; it does not duplicate their ledgers or silently revise their conclusions.

## Compaction and reconstruction

After suspected context loss:

1. load the latest explicit user constraints;
2. load the canonical state;
3. inspect actual workspace and tool/environment state;
4. verify the last checkpoint anchor;
5. invalidate stale evidence;
6. reconstruct one next safe action.

Conversation history is supporting context, not the authority. If the record is missing or incomplete, reconstruct only what observable evidence supports and label the rest unknown.

## Security and disclosure

Never persist secrets, raw credentials, session cookies, private keys, tokens, or unnecessary sensitive payloads. Use a non-secret pointer such as `credential expected in owner-managed secret store` when needed. Apply repository access and retention expectations to the state artifact itself.

Before sharing a handoff, remove incidental sensitive content while preserving the fact that a secret-dependent boundary exists.
