# Consequence Control

Read this reference for deletion, destructive commands, migration, production mutation, deployment, release/publication, external messages, payments, permission changes, broad configuration changes, irreversible transformations, or other externally effective actions.

Consequence Control gates a transition. It is not deployment automation or an operations control plane.

## Define the transition

Record:

- current lifecycle state and proposed next state;
- exact target identity and environment;
- requested operation and responsible owner/operator;
- intended outcome and observable success;
- timing and dependency conditions;
- consequence of success, partial success, duplicate execution, delay, and failure.

Do not infer production from a filename, command name, branch, environment variable, or narrative label. Verify the target through current environment-specific evidence.

## Fact and projection discipline

Keep these assertion types separate:

- **VERIFIED CURRENT FACT:** directly supported present state, such as an observed schema mismatch or a missing authorization record.
- **PROJECTED CONSEQUENCE:** an evidence-based outcome that may follow if the transition occurs.
- **POTENTIAL RISK:** a possible harm and its conditions, likelihood, or materiality.
- **REQUIRED CONTROL:** a precondition or safeguard needed to cross the boundary.

Use causal, calibrated wording. For example: `Current evidence shows a schema mismatch; cutover creates a material risk of runtime failure and potential data-integrity consequences.` Say `will corrupt data` only when direct evidence establishes that deterministic result for the exact transition. Likewise, distinguish `the repository contains a secret-bearing artifact` from `the publication path could expose it if included`.

## Blast-radius model

| Dimension | Question |
|---|---|
| Assets/data | What changes, moves, becomes visible, or can be lost? |
| Subjects | Which users, tenants, customers, accounts, or systems are affected? |
| Scope | Single item, batch, tenant, region, service, account, or global? |
| Location | Local fixture, staging, production, public, or third-party? |
| Timing | Immediate, delayed, queued, scheduled, recurring, or propagating? |
| Privilege | Does the action grant, revoke, inherit, or expand capability? |
| Availability | Can it degrade, lock, overload, or interrupt service? |
| Financial/legal/privacy | Can it spend, transfer, notify, bind, disclose, retain, or delete? |
| Dependencies | Which downstream consumers, caches, jobs, replicas, or providers react? |
| Visibility | Private, customer-visible, public, indexed, emailed, messaged, or published? |
| Reversibility | What exact state and evidence are required to restore? |

Minimize the reachable scope while preserving the authorized outcome.

## Precondition gate

Select only material preconditions:

- target and environment identity verified;
- owner and operational authority current;
- native permission path known;
- input set and selection query reviewed;
- dependency/provider health adequate;
- compatibility, data, and security conditions verified;
- idempotency, concurrency, duplicate, and partial-failure behavior understood;
- backup/snapshot/transaction or other recovery control established where required;
- rollback is viable or irreversibility explicitly accepted by an authorized owner;
- monitoring/observation is ready;
- stop/abort threshold and response owner defined;
- communication or maintenance window ready when necessary.

Failure of a material precondition blocks the transition. Safe local preparation, dry-run, validation, or artifact creation may continue when it cannot cross the boundary.

## Control selection

Choose controls by the failure path:

- dry-run or preview for target/scope uncertainty;
- staging or representative isolated fixture for behavior uncertainty;
- canary or scoped rollout for broad production consequence;
- transaction, idempotency key, deduplication, or checkpoint for partial/duplicate execution;
- backup/snapshot/export for recoverable state loss;
- expand-and-contract or compatibility window for migrations;
- feature flag or kill switch for bounded activation;
- least privilege and time-bounded credentials for authority scope;
- rate/cost/recipient cap for financial or messaging consequence;
- observation window and automatic/manual stop threshold for rollout risk.

Do not require every control. A control must reduce a specific risk and itself be feasible, authorized, and verified enough.

## Action-specific concerns

### Deletion and destructive commands

Resolve the exact target without broad globs or ambiguous variables. Prefer preview/count/list, immutable backup where required, bounded batch, and post-action verification. Never broaden a target to make a command easier.

### Migration and production data

Check mixed-version compatibility, transaction boundaries, locks, ordering, backfill, retry/idempotency, partial application, schema/data invariants, restoration, and observation. A migration file existing is not a migration applied; a command starting is not completion.

### Deployment, release, and publication

Bind source/artifact identity to target/environment. Verify required checks, configuration/secrets availability without exposing values, rollout scope, health/telemetry, rollback anchor, and public visibility. Local build success does not establish deployed behavior.

### External messages and publication

Verify audience/recipient, content, attachment/link, channel/account, privacy, timing, duplication, and whether sending is reversible. Drafting is not authorization to send.

### Payments and financial action

Verify amount, currency, beneficiary, account/environment, idempotency, fees, limits, authorization, and confirmation/settlement semantics. A prepared payment is not executed; provider acceptance is not necessarily settlement.

### Permission and configuration changes

Compare before/after scope, inheritance, affected principals/resources, privilege expansion, propagation delay, lockout risk, and recovery access. Prefer minimum necessary scope and a tested path to restore administrative control.

## Gate and execution boundary

`PROCEED` or `PROCEED WITH CONTROLS` applies only to the named target, operation, environment, time/condition, evidence, and authority. Any material change requires re-gating.

The parent workflow/operator executes through native tools and permissions; the risk case does not grant new scope. After execution, observe actual target state and record the exact lifecycle state. Do not promote:

```text
AUTHORIZED -> EXECUTED
EXECUTED -> OBSERVED
OBSERVED -> COMPLETE
```

without separate evidence.

## Residuals

State what could still fail, which users/assets remain exposed, what was not observed, how long controls remain necessary, and the trigger for stop, rollback, escalation, or re-assessment.
