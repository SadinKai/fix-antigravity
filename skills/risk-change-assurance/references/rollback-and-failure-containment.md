# Rollback and Failure Containment

Read this reference when reversibility, backups, partial effects, live-action failure, rollout stopping, or rollback controls the gate.

Rollback is a consequential action with its own risk case. A command-shaped idea is not a viable rollback.

## Reversibility classification

- **FULLY REVERSIBLE:** the prior state can be reconstructed within required time and scope using verified preserved state and procedure.
- **PARTIALLY REVERSIBLE:** some effects, data, notifications, cost, or external propagation cannot be restored.
- **DIFFICULT TO REVERSE:** restoration is technically possible but slow, risky, capacity-limited, or dependent on uncertain external conditions.
- **IRREVERSIBLE:** material effects cannot be undone or reconstructed.

State the basis. Do not call an action reversible because a theoretical inverse command exists.

## Rollback viability gate

Establish:

- exact current target and candidate rollback target, with the evidence-supported property of that candidate;
- preserved source/data/configuration/artifact needed to restore;
- backup/snapshot identity, scope, integrity, freshness, and accessibility;
- compatible rollback procedure and tooling;
- authority and native permission for rollback;
- dependency/provider availability;
- data written after the anchor and how it is reconciled;
- time objective and capacity;
- restore/rollback rehearsal or other strong evidence where consequence warrants it;
- post-rollback health, integrity, and observation oracle;
- stop/escalation conditions if rollback fails.

If a material prerequisite is unverified, label rollback viability accordingly and do not use it to justify a higher-risk forward action.

Use target labels precisely:

- **CURRENT TARGET:** the target in use now; no health or qualification claim is implied.
- **PREVIOUS TARGET:** an earlier target; prior existence or use does not make it known-good.
- **OBSERVED HEALTHY TARGET:** health was observed under stated conditions and time.
- **TESTED ROLLBACK TARGET:** the rollback path to that target was exercised under stated conditions.
- **QUALIFIED ROLLBACK BASELINE:** the target and restoration procedure passed the defined target-specific qualification gate.

Use `known-good` or `rollback-safe` only when the exact relevant properties, environment, recency, restoration procedure, and post-rollback oracle are supported. Otherwise name the target as current, previous, candidate, observed healthy, or tested, and state the missing qualification.

## Backups

A backup exists only when its artifact and scope are established. For a consequential gate, consider whether it is:

- for the correct target/environment;
- recent enough for the stated loss tolerance;
- complete for dependent state;
- protected from the forward action;
- readable/decryptable with current authorized access;
- restorable into a compatible environment;
- tested or otherwise evidenced proportionately.

`Backup configured` is weaker than `restore path demonstrated`. Do not expose backup credentials or sensitive contents in the risk record.

## Live failure sequence

When a consequential action fails or reports ambiguous status:

```text
STOP EXPANSION
-> PRESERVE LOGS, IDS, OUTPUT, TARGET, TIME, AND CURRENT STATE
-> PREVENT DUPLICATE OR BROADER EFFECTS
-> INSPECT ACTUAL PARTIAL SIDE EFFECTS
-> CONTAIN WITHIN PRE-AUTHORIZED BOUNDS
-> FOLLOW ONLY AN APPROVED RECOVERY / ROLLBACK PROCEDURE
-> CONTINUITY RECONCILES ACTUAL STATE
-> RISK RE-EVALUATES THE NEXT TRANSITION
```

Do not retry a destructive command until actual effects and idempotency/duplicate behavior are known. Tool error does not mean no mutation; command success does not mean intended state.

## Partial execution

Classify:

- no effect established;
- partial effect with known boundary;
- action complete but reporting/observation failed;
- unknown effect;
- duplicate or concurrent effect possible.

Determine affected records/resources/users, downstream propagation, locks/transactions, queued work, retries, compensating actions, and current authority. Preserve current user/external changes; do not reset blindly to a checkpoint.

## Containment

Containment limits further consequence. Examples include pausing rollout, disabling an activation flag through an approved path, stopping a batch at its defined boundary, revoking a compromised capability through owner procedure, isolating a tenant/queue, or switching to a pre-authorized safe mode.

Containment must itself be scoped, authorized, observable, and reversible where possible. The skill recommends and gates; native tools/permissions and the authorized operator execute.

## Rollback decision

Risk may decide that rollback is required or appropriate. It must state:

- reason and triggering evidence;
- exact target/anchor;
- what rollback can and cannot restore;
- current authority and permission boundary;
- protected user/external changes;
- procedure owner;
- verification and observation after rollback;
- residual risk.

Never silently roll back. User urgency does not waive missing target verification, authority, or a material prerequisite.

## Recovery interaction

Continuity & Recovery owns the reconciled current task state and failed-strategy history. Risk supplies the containment/rollback gate, preconditions, stop condition, and observed result. After any failed or partial live action, do not resume the old plan until Continuity has reconciled actual state and Risk has re-gated the next consequential step.
