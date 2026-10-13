# Contradictions, Freshness, and Absence

Read this reference when sources conflict, facts may drift, or the conclusion claims something is absent.

## Contradiction protocol

Do not average disagreements or hide them inside a smooth narrative.

1. Write the exact proposition asserted by each source.
2. Separate semantic disagreement from different definitions or scopes.
3. Compare publication/update and observation dates.
4. Compare product/model/software versions and rollout stage.
5. Compare configuration, environment, platform, region, plan, and jurisdiction.
6. Compare authority, directness, source independence, and evidence method.
7. Check whether one source actually supersedes the other within the applicable scope.
8. Identify and seek the observation that would distinguish the live alternatives when its information value justifies the effort.
9. State what is verified and what remains `CONDITIONAL` or `UNRESOLVED`.
10. State the practical implications of each live alternative without promoting an implication into a decision.
11. Hand any consequence, control, gate, or authorization decision to its owner.

Use a compact conflict record:

| Claim A | Claim B | Material difference | Discriminating evidence | Result |
|---|---|---|---|---|

Valid conclusions include:

- `A is supported for version/configuration X; B is supported for Y.`
- `The current environment matches X, so A applies.`
- `The governing condition is unknown; conclusion remains CONDITIONAL.`
- `UNRESOLVED because credible evidence still conflicts.`

## Decision ownership after contradiction

Keep these output types distinct:

- **EVIDENCE CLAIM:** what the evidence supports, including an applicable external requirement stated by an authoritative source.
- **IMPLICATION:** what follows conditionally if a stated evidence claim governs.
- **RECOMMENDATION:** optional advice derived from evidence and explicitly labeled as advice.
- **RISK DECISION:** the consequence/control decision owned by Risk & Change Assurance.
- **AUTHORIZATION DECISION:** permission owned by the applicable user, system, procedure, or authority.
- **CONSEQUENTIAL GATE:** the transition decision owned by Risk & Change Assurance.

Evidence Research owns the evidence claim and its provenance, uncertainty, conflict analysis, and conditional implications. It may provide a clearly labeled recommendation when useful. It must not emit an unqualified Risk decision, authorization decision, consequential gate, or mandatory operational action under the guise of evidence.

For an unresolved conflict, state the competing propositions and the implications if each governs, preserve `UNRESOLVED`, and hand the decision to its owner. Do not select the stricter or more conservative alternative merely because it appears safer. Caution, security relevance, or consequence does not transfer ownership.

An authoritative regulator, vendor, standard, or policy may itself establish an external requirement. Report that requirement as a sourced evidence claim and state a conditional implication such as `if requirement X governs this target, the target must satisfy X`. Do not derive a separate internal gate unless the applicable source explicitly establishes that gate. If a Risk or authorization decision is supplied by its actual owner, preserve it by provenance pointer and consume it without rewriting the evidence conclusion. If the decision owner is unclear, report `DECISION OWNERSHIP UNRESOLVED` rather than inventing a decision.

## Documentation versus behavior

Keep these claims distinct:

- documentation says a feature exists;
- source code contains an implementation;
- the installed version contains it;
- the current environment exposes it;
- the behavior was observed under stated conditions;
- the behavior is reliable for all users/platforms.

Evidence for one does not automatically prove the next.

## Freshness model

Do not use a universal expiration window. Estimate staleness from how likely the underlying fact is to change before the decision or action occurs.

### Target-relative freshness and scope-aware supersession

Freshness is a relationship between evidence, a proposition, and the target state. A document published yesterday may be inapplicable; an older document may still govern an older deployed target. Do not use source date as a proxy for target applicability.

For a freshness-sensitive claim, compare only the dimensions that could materially change its truth:

```text
CLAIM TARGET
SOURCE DATE / VERSION / SCOPE
TARGET VERSION / SCOPE
SOURCE ROLLOUT OR DEPLOYMENT STATE
TARGET ROLLOUT OR DEPLOYMENT STATE
SOURCE RUNTIME / PLATFORM / MODE
TARGET RUNTIME / PLATFORM / MODE
SUPERSESSION RELATIONSHIP
APPLICABILITY
FINAL CLAIM
```

Keep these concepts distinct: current source, current target state, latest document, latest release, latest available version, latest supported version, latest announced version, and latest deployed version.

Rollout or availability evidence may describe `ANNOUNCED`, `PRERELEASE`, `BETA`, `CANARY`, `STAGED ROLLOUT`, `LIMITED AVAILABILITY`, `GENERALLY AVAILABLE`, `DEPLOYED TO TARGET`, `NOT DEPLOYED TO TARGET`, `WITHDRAWN`, or `SUPERSEDED`. Use the source's supported state rather than promoting one state to another. `Released` does not prove `deployed to target`; `generally available` does not prove this target has received it.

Preserve absence scope in the other direction. A future general-availability date supports `not yet generally available` as of the research date; it does not by itself prove `unavailable` for a target or everywhere, or exclude preview, early-access, regional, or tenant-specific deployment. When target availability evidence is absent, use `UNRESOLVED` or `NOT ESTABLISHED`; use `NOT DEPLOYED` or `UNAVAILABLE` only when target-specific evidence establishes that negative state. State only the availability class the evidence establishes.

Declare newer evidence to supersede older evidence for the target only when the newer evidence governs the same claim domain and materially aligns with target version/branch, runtime, platform/deployment mode, rollout/deployment state, and any relevant edition, region, cohort, or configuration. If a material dimension is unknown, state the bounded relationship, for example: `B supersedes A for version X and later; applicability to target Y remains unverified.`

Useful combined outcomes include:

- `CURRENT AND APPLICABLE`;
- `CURRENT BUT NOT APPLICABLE`;
- `CURRENT WITH TARGET VERSION OR DEPLOYMENT UNKNOWN`;
- `FUTURE / NOT YET APPLICABLE`;
- `HISTORICAL AND APPLICABLE TO TARGET`;
- `SUPERSEDED FOR TARGET`;
- `SUPERSEDED OUTSIDE TARGET`;
- `SCOPE OR APPLICABILITY UNKNOWN`.

Do not overcorrect by preferring old evidence. When the target is verified to match the newer version, rollout/deployment, runtime, platform, and material scope, the newer governing evidence may supersede the older evidence for that target.

### Highly volatile

Prices, availability, outages, current releases, active advisories, live provider status, current capabilities, rollout state, and real-time policy or market conditions.

Prefer evidence observed close to the action boundary. Record an event- or time-based refresh condition.

### Moderately volatile

API behavior, software compatibility, package versions, platform limitations, vendor guidance, and active product documentation.

Bind evidence to version/configuration and refresh on upgrade, deployment, or material documentation change.

### Slowly changing

Mathematical facts, stable definitions, and established historical facts.

External refresh is often unnecessary unless the framing or source attribution is disputed.

For every reusable volatile result, record:

- researched/accessed date;
- validity conditions;
- decision/action boundary;
- invalidating event;
- next refresh requirement.

Fresh means still valid for the claim, not merely recently published.

## Future-actionable refresh conditions

A refresh condition names the next future reason to revalidate from the research date. First determine whether a candidate event has already occurred.

- **Current condition already reached:** incorporate it into the present conclusion; do not present it as a future trigger.
- **Scheduled future event:** name the future date or event and refresh at an action-appropriate boundary.
- **Conditional future transition:** name the observable change, such as a version, policy, rollout, configuration, or provider-state change.
- **Routine periodic revalidation:** use a justified cadence only when ongoing volatility warrants it.

If a product has already reached end of life, `refresh when end of life occurs` is stale wording. Use a still-future trigger such as an upstream/downstream support-policy change, a relevant release or compatibility change, a changed target environment, or the next decision boundary. Do not invent a future event merely to fill the field; state `no scheduled refresh, revalidate on material change` when that is accurate.

## Absence discipline

Distinguish:

- `NOT FOUND`: the bounded search did not locate it;
- `NOT DOCUMENTED`: the inspected documentation did not state it;
- `NOT OBSERVED`: the stated observation did not show it;
- `DOES NOT EXIST`: the evidence method supports an absence conclusion in the defined scope.

An absence claim needs a closed or sufficiently enumerable search space, an authoritative inventory, a decisive query/inspection, or another method capable of detecting the item if present.

Record the searched scope, source coverage, query or observation, date/version, and known blind spots. If the search space is open or access is incomplete, report `NOT FOUND`, `UNRESOLVED`, or `BLOCKED` rather than absence.

## Search-loop exit

Repeatedly finding the same unsupported assertion is not progress. Change source family, query framing, version, environment, evidence type, or hypothesis. Stop when another search has little chance of changing the decision, and disclose the residual.
