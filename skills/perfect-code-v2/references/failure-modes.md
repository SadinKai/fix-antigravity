# Failure Modes

Read this reference for deeper adversarial review. Select only categories reachable from the task; do not mechanically check all of them.

For each selected class ask:

> What concrete event, input, state, or dependency behavior would make the acceptance claim false, and what evidence could expose it?

## Input and representation

Missing/null, malformed, unexpected type/shape, empty, duplicate, boundary, huge/adversarial, encoding, precision, locale, clock, order.

## State and lifecycle

Stale state, illegal transition, partial initialization, restart/recovery, repeated execution, inconsistent cache, teardown/cleanup, ownership transfer, version skew.

## Errors and control

Partial failure, swallowed/misclassified error, timeout, retry storm, non-idempotent retry, cancellation ignored, fallback masking failure, cleanup failure.

## Concurrency and distribution

Race, lost update, duplicate work, deadlock, ordering/visibility bug, split state, partition, stale read, lock/resource leak.

## Security and trust

Broken authentication/authorization, tenant crossing, injection, unsafe deserialization, secret leakage, privilege escalation, source-to-sink reachability, trust-boundary bypass, unsafe diagnostics.

## Data and migration

Wrong transaction boundary, partial persistence, schema mismatch, lossy transform, backfill drift, mixed-version incompatibility, rollback/restore failure, precision loss, hidden ordering assumption.

## Dependencies and external systems

Unavailable or malformed dependency, version/protocol mismatch, rate limit, changed contract, network partition, unexpected latency, partial response, authentication expiry.

## Resources and operations

Unbounded memory/queue, descriptor exhaustion, hot loop, blocking call, startup/shutdown failure, configuration drift, missing/misleading observability, unhealthy rollback.

## Architecture and requirements

Accidental coupling, duplicate source of truth, circular dependency, abstraction leakage, incorrect responsibility split, unnecessary public surface, omitted acceptance claim, compatibility break.

## Evidence and harness

Zero tests executed, partial/truncated output, stale artifact, wrong environment, mock hiding behavior, self-authored oracle sharing the defect, tool failure mistaken for product failure, unavailable external state inferred as success.

Select failure classes by reachability, consequence, uncertainty, and evidence deficit. A completed checklist is not proof of completeness.
