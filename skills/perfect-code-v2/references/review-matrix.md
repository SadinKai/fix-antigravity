# Risk-Weighted Review Matrix

Read this reference when selecting audit lenses for COMPLEX or CRITICAL engineering work. Choose only lenses capable of changing the conclusion.

## Priority

Default order:

1. required behavior and correctness;
2. security, safety, and data integrity;
3. compatibility and externally visible contracts;
4. reliability, lifecycle, and failure handling;
5. simplicity and architecture;
6. maintainability and testability;
7. performance and resource behavior;
8. local style.

Task evidence may elevate a lower item. Formatting tools, not review attention, should own routine style.

## Surface selection by claim

| Claim/lens | Surfaces likely to matter | Stronger evidence |
|---|---|---|
| Functional behavior | entry point, callers, branches, outputs, side effects, consumers | reproduction, contract/integration tests, runtime behavior |
| Negative paths | errors, timeouts, retries, cancellation, cleanup, partial success | fault injection, failure tests, traces |
| State/lifecycle | initialization, transitions, persistence, restart, teardown | state model, transition tests, restart/recovery exercise |
| Concurrency/distributed | ownership, ordering, atomicity, idempotency, visibility, duplicate work | stress/fault tests, happens-before reasoning, runtime traces |
| Security/auth | assets, actors, sources/sinks, trust and tenant boundaries, permissions | threat model, static/dataflow analysis, denial/isolation tests, authorized reproduction |
| Data/migration | schema, transforms, transactions, compatibility, backfill, rollback | invariants, migration audit, reconciliation, restore/rollback evidence |
| Architecture | responsibility, dependency direction, source of truth, public surface | dependency/ownership graph, change-impact evidence, repository conventions |
| Performance | hot path, algorithm, I/O, allocation, contention, caching | representative profile, trace, benchmark, load test |
| Dependency/configuration | manifest/lockfile, installed version, runtime config, protocol | build, compatibility check, official source, observed installed behavior |
| UI/browser | client/server boundary, state, timing, focus, accessibility, responsive behavior | browser/DevTools, console/network, accessibility tree, screenshots/video |
| Deployment/operations | build artifact, environment, startup, health, observability, rollout/rollback | deployment records, health/telemetry, environment diff, rehearsal |
| Requirement coverage | acceptance claim, implementation site, test/oracle, residual | requirement-to-evidence mapping |

## Scope levels

### File

Use for a localized claim. Review responsibility, control/state flow, error paths, public surface, dependencies, readability, and the complete diff.

### Subsystem

Use when behavior crosses modules. Review contracts, responsibility duplication, transformations, lifecycle, caching, retries, cancellation, state ownership, dependency direction, and races.

### Repository/environment

Use only when the claim can cross those boundaries. Inspect callers/consumers, tests, manifests, configuration, generated boundaries, build/runtime effects, migrations, deployment, external dependencies, and overlapping utilities.

A repository review should not mean reading every file. Partition by consequential surface and record material exclusions.

## Consequence boundary

Perfect Code may identify technical security, migration, production, rollback, or authorization risk. Risk & Change Assurance should lead the consequence gate when available. Without it, do not infer authorization, safe rollout, deployment, or external observation from source-level evidence.

## Review output

Prefer a small number of evidence-backed material findings. For each, provide the causal path, evidence, impact, confidence, and scope. Separate:

- confirmed defect;
- strongly supported concern;
- unresolved hypothesis;
- residual/unsearched surface;
- non-material improvement.
