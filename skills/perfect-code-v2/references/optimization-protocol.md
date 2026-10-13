# Optimization and Rewrite Protocol

Read this reference when materially different designs are plausible, a rewrite is proposed, or performance/complexity improvement is part of the contract.

## Hard constraints and objectives

Hard constraints cannot be traded away: required behavior, acceptance criteria, security, data integrity, required compatibility, authorization boundaries, and explicit performance/SLO requirements.

Objectives can be traded carefully: simplicity, maintainability, testability, non-required local performance, extensibility, and style consistency.

## Start with removal

Ask whether work, state, transformation, dependency, abstraction, configuration, synchronization, or I/O can disappear while preserving the contract.

Prefer:

`eliminate → simplify → reuse sound local pattern → improve algorithm/data structure → improve implementation → micro-optimize`

## Generate candidates only when real

Consider materially distinct approaches when plausible:

1. simplest direct implementation;
2. sound existing repository abstraction;
3. more sophisticated architecture/algorithm only when the requirement justifies it.

Do not fabricate alternatives for an obvious local change.

## Compare

For each serious candidate identify:

- concrete problem solved and evidence;
- hard-constraint compatibility;
- correctness and failure modes;
- state, coupling, and complexity;
- security and data implications;
- performance/resource behavior;
- testability and maintainability;
- dependency/operational cost;
- integration, migration, and rollback impact;
- verification plan and oracle strength.

Reject any candidate that violates a hard constraint. When sound candidates are effectively tied, prefer lower complexity and lower risk.

## Rewrite threshold

Rewrite for a demonstrated defect, material security/reliability gap, meaningful unnecessary complexity, materially better architecture/testability, measured meaningful performance improvement, or required compatibility correction.

Do not rewrite for style preference, fewer lines alone, a merely equivalent alternative, theoretical speed without a relevant bottleneck, or cosmetic rearrangement.

## Reversible comparison

For substantial rewrites use:

`BASELINE → CANDIDATE → VERIFY → KEEP or REJECT`

Compare relevant API behavior, outputs, errors, side effects, persistence, ordering, compatibility, performance, and resources. If evidence does not show material dominance, preserve the sound current implementation.

More iterations do not imply higher quality. Stop when no known candidate offers justified material improvement.
