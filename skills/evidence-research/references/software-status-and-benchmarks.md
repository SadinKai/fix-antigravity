# Software Status, Community Reports, and Benchmarks

Read this reference for software, API, model, release, issue, advisory, rollout, compatibility, or benchmark claims.

## Version-first software research

Establish where possible:

- installed/current version;
- target version;
- source/documentation version;
- configuration and feature flags;
- platform, region, plan, and rollout cohort;
- release, preview, beta, deprecation, and support status;
- observation date and environment.

Do not let an old source silently govern a newer target. Do not assume the newest documentation describes the installed environment.

## Release and lifecycle taxonomy

Use lifecycle labels only when applicable evidence assigns or directly supports them.

### Lifecycle category non-derivation

Treat every lifecycle label as a semantic proposition, not as an interpretation of version arithmetic or chronology. For each material lifecycle-sensitive claim establish:

```text
SUBJECT
VERSION OR RANGE
PROPERTY BEING CLAIMED
DIRECT EVIDENCE FOR THAT PROPERTY
CLASSIFICATION
CONFIDENCE
FINAL WORDING
```

Evidence showing only a version number, release date, order, changelog, artifact name, release count, age, or distance from end of life cannot assign a lifecycle category. If no applicable evidence establishes the category, report `release occurred` or `category UNRESOLVED` rather than inventing a label.

Keep these measures independent whenever they matter:

| Proposition | Required basis |
|---|---|
| Version or patch delta | Version arithmetic; label as derived |
| Number of releases | An applicable enumerated release set |
| Number of bugfix releases | Category evidence covering each counted release or a homogeneous documented range |
| Number of security-only releases | Category evidence covering each counted release or a homogeneous documented range |
| Number of source-only releases | Source-only evidence covering each counted release or range |
| Releases with official platform binaries | Applicable official artifact/support evidence |
| Final release identity | Evidence identifying the official final release |
| End-of-life date/status | Applicable upstream or vendor lifecycle evidence |

Never substitute one row for another. In particular, a patch-number gap or number of later releases is not a count of security-only releases.

### Range and boundary discipline

Before applying one label to a range, verify that the range is homogeneous for the claimed property. Split at evidence-based boundaries when a range crosses bugfix to security-only, supported to end-of-life, official binary to source-only, or one vendor policy to another. Establish the transition boundary and the evidence that makes it applicable; do not assume that every later release inherits an identical property.

`Final release` is an evidenced status of an official branch or series, not the numerically highest version string found. A later unofficial build or prerelease does not change the official final release without governing evidence.

### Semantic distinctions that must survive compression

- `Security fixes included` describes release content; it does not establish a `security-only` lifecycle.
- `No official vendor binaries` does not mean no community or unofficial binaries exist.
- A release after a policy date is not automatically in that policy class unless the policy applies to it.
- Arithmetic may establish patch increments, release count, elapsed time, or ordering. Label those as derived and do not attach an unevidenced lifecycle category.

When final prose combines lifecycle facts, every relationship must survive the same evidence test. Split the sentence if compression would turn a numeric fact, content fact, or chronology fact into a category claim.

- **Development/feature phase:** prerelease or active feature-development period identified by the governing project.
- **Bugfix release/phase:** release or maintenance period that accepts ordinary correctness fixes under the project's stated policy.
- **Security-only release/phase:** release or period explicitly limited to security fixes; earlier bugfix releases do not become security releases merely because they precede this phase.
- **Source-only availability:** source artifacts are published while supported packaged binaries or installers are absent for the relevant platform.
- **Packaged binary availability:** official or applicable downstream binaries/installers exist for the named platform and version; this is separate from source availability.
- **Final release:** the project's last release in the stated line only when the source says so; it is not automatically the end-of-life date.
- **End of life:** the date or state after which the named upstream support commitment ends.
- **Downstream/vendor support:** support supplied by a distributor, platform, or vendor and scoped separately from upstream lifecycle status.

A version line may cross bugfix, security-only, source-only, downstream-supported, and end-of-life states over time. State which release/date belongs to which phase and preserve uncertainty when the source does not classify it. The same invariant applies to runtimes, libraries, APIs, operating systems, cloud services, firmware, databases, browsers, and vendor maintenance windows.

## Evidence types for software claims

| Evidence | What it can establish | What it does not automatically establish |
|---|---|---|
| Official documentation | Vendor-documented contract or guidance | Installed/runtime behavior or universal reliability |
| Changelog/release note | Vendor says a change shipped in a named release | Every user/platform received it or the symptom is eliminated |
| Source repository/tag | Code exists at a revision | Packaged, enabled, configured, or deployed behavior |
| Installed metadata/source | The local artifact/version contains something | End-to-end behavior in the target environment |
| Runtime observation | Behavior occurred under stated conditions | Universal behavior outside those conditions |
| Issue report | A report and its stated status/environment exist | Current prevalence or reproducibility on the latest release |
| Advisory/database | A publisher identifies affected scope and mitigation | The local system matches that scope without version/config evidence |

## Issue and release status

- **Open issue:** a report remains open. It does not prove the latest release still reproduces the defect.
- **Closed issue:** the issue is closed. It does not prove every environment is fixed or the symptom is impossible.
- **Fixed label/commit:** a change is associated with a fix. Establish the release/build containing it and the target’s actual version.
- **Changelog entry:** the vendor says a change shipped. Check rollout, platform, and installed version before claiming applicability.
- **Release announcement:** a release was announced. It does not automatically prove rollout completion or local availability.

Prefer a conditioned result: `reported on version X; vendor says fixed in Y; current environment Z was not reproduced/observed`.

## Community evidence

For each material community report record:

- exact environment/version/date;
- reproduction detail;
- whether reports are independent;
- whether the behavior was reproduced elsewhere;
- supporting or contradictory primary evidence;
- historical versus current relevance.

Several reports establish multiple reports, not frequency. Do not use anecdotal counts as prevalence data.

## Security advisory claims

Record advisory authority, identifier, publication/update date, affected and fixed versions, configuration preconditions, exploitation status if actually supported, and remediation/mitigation scope. Cross-check the target’s installed version and configuration.

Evidence Research supplies facts. Risk & Change Assurance owns the action/consequence decision. Missing current advisory evidence can block a critical decision.

## Benchmark and model comparisons

Always record:

- benchmark name and version;
- evaluation date;
- exact model/version;
- harness, tools, prompting/task setup, sampling, and budget when available;
- vendor versus independent result;
- metric definition and task distribution;
- whether compared numbers use matched conditions;
- known contamination, reproducibility, or coverage limits.

Do not turn `Model A scored higher on benchmark X under setup Y` into universal superiority. If harnesses or task versions differ, report that numbers are not directly comparable.

Vendor benchmarks are valid evidence of what the vendor reported under its stated setup, not independent confirmation. Independent evaluations can also be inapplicable, stale, or methodologically weak; evaluate them rather than assuming independence guarantees quality.

## Compatibility conclusion pattern

A useful software conclusion states:

```text
For target version/config/environment T, source S directly supports behavior B as of date D.
Runtime behavior was OBSERVED / not observed / unavailable.
Compatibility is VERIFIED / CONDITIONAL / UNRESOLVED within scope Q.
Refresh on the next future material change after research date D: target version, rollout, configuration, provider state, or applicable support policy.
```
