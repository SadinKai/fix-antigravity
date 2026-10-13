# Verification and Oracle Strategies

Read this reference when choosing non-trivial verification, when tests may share implementation assumptions, or when the available oracle is weak.

## Start from the claim

Define what must be observed and in which environment. Then choose the oracle. Do not begin with “run all tests” unless the suite is the right evidence for that claim.

| Claim | Candidate oracle |
|---|---|
| Syntax/style | parser, formatter, linter |
| Type/interface compatibility | compiler, type checker, API/schema validator |
| Isolated rule/transformation | focused unit test, property test |
| Component interaction | integration/contract test with real boundary behavior |
| User-visible multi-layer behavior | end-to-end or browser/DevTools observation |
| Data/state transition | invariant and transition tests, reconciliation |
| Concurrency/retry/idempotency | stress, schedule/fault injection, duplicate-execution test |
| Security reachability | threat/dataflow analysis, scanner, denial/isolation test, authorized safe reproduction |
| Migration completeness | structural audit plus behavioral/compatibility checks |
| Performance/resource use | representative profile, benchmark, load/soak test |
| Deployment/operations | actual build/artifact, environment checks, health/telemetry, rollback rehearsal |
| Current external behavior | observed API/provider result and authoritative versioned source |

## Oracle-strength classification

### Strong

Independent deterministic or runtime evidence directly exercises the material claim in the relevant environment.

### Moderate

Focused integration evidence or repeatable behavior covers the claim meaningfully but leaves a known boundary.

### Weak

The evidence is a proxy, a shallow mock, a self-authored test sharing the implementation’s assumptions, a partial run, or an environment mismatch.

### None

Reasoning-only assertion, an unavailable observation, or a tool invocation whose result/coverage was not established.

Strength is claim-relative. A compiler can strongly establish type correctness but says little about runtime authorization.

## Verification methods

### Unit and characterization

Use for deterministic local behavior and preserving existing behavior before a refactor. Avoid tests coupled only to implementation shape.

### Integration and contract

Use when correctness depends on serialization, schemas, database behavior, real adapters, configuration, or component boundaries.

### End-to-end and browser

Use for user-visible paths, navigation, session/auth flows, client/server integration, timing, focus, responsive behavior, and accessibility. Record the browser/device/environment actually observed.

### Property-based and fuzz

Use to explore broad input/state spaces from explicit invariants. One discovered bug does not prove neighboring cases are covered.

### Differential

Use when a trusted reference implementation, previous version, or independent system can decide equivalent behavior.

### Metamorphic

Use when exact outputs are hard to enumerate but relations should hold, such as idempotence, round trips, scaling, or permutation invariance.

### Concurrency and fault injection

Use for races, duplicate work, ordering, retries, timeouts, cancellation, partial failure, cleanup, and recovery.

### Mutation testing

Use selectively when test adequacy is important and ordinary coverage may hide plausible wrong implementations.

### Performance

Establish a baseline, use representative workloads, measure like with like, record environment/variance, and distinguish measured results from algorithmic inference. Never invent benchmark results.

## Test-adequacy challenge

Ask:

- Which acceptance claim lacks direct evidence?
- What plausible incorrect implementation would still pass?
- Do implementation and test encode the same assumption?
- Did the command run the intended tests, or zero/partial tests?
- Which negative path, state transition, integration, or environment remains outside the oracle?
- Did the last meaningful change occur after the evidence was produced?

If the answer exposes a material gap, strengthen the oracle, use a different evidence source, or lower the completion claim.

## Partial and failed validation

Check exit status, executed test count/scope, skipped tests, truncation, configuration, environment, and artifact freshness. A successful command is not automatically successful evidence.

When no reliable oracle exists, use the best triangulation available, consider one native fresh-context verifier for high-consequence work, and report `UNVERIFIED` or the exact residual rather than inventing proof.
