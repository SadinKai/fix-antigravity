# Example Workflows

These examples demonstrate intended routing. They do not prove which skills a particular model loaded; inspect the behavior and evidence produced.

For a small executable fixture, follow [the first-success demo](first-success/README.md). For controlled trials and current NOT RUN results, see [the evaluation protocol](../docs/evaluation.md).

## 1. Repository bug

**Prompt**

```text
Fix the duplicate notification bug in this repository. Reproduce it, trace the causal path, preserve unrelated behavior, make the smallest justified change, run the focused and relevant regression tests, and report residual uncertainty.
```

**Active:** Perfect Code V2. **Dormant unless evidence changes the task:** Evidence Research, Continuity & Recovery, Risk & Change Assurance.

## 2. Current factual question

**Prompt**

```text
Verify from authoritative current sources whether the latest stable release supports this option on Windows. State the exact version, access date, applicability conditions, contradictions, and whether the claim is documented, observed, or reproduced.
```

**Active:** Evidence Research. Perfect Code V2 joins only if repository or runtime engineering becomes part of the request.

## 3. Interrupted task and changed tree

**Prompt**

```text
Resume the parser refactor from the saved checkpoint. Before editing, reconcile the checkpoint with the actual branch, dirty working tree, and test state. Preserve changes that are not ours, identify the first divergence, and continue only from a verified next action.
```

**Lead:** Continuity & Recovery. **Support:** Perfect Code V2 after reconciliation.

## 4. Missing rollback evidence

**Prompt**

```text
Do not deploy. Gate this hypothetical production migration. The change passed local tests, but the backup has not been restored in a rehearsal and the approving owner is unknown. Assess authority, blast radius, rollback viability, controls, observation, stop conditions, and give the explicit gate.
```

**Lead:** Risk & Change Assurance. Engineering evidence remains scoped to local verification; it cannot authorize the transition.

## 5. Integrated dependency change

**Prompt**

```text
Determine whether the maintained release of dependency X fixes advisory Y for our exact runtime, then implement the smallest compatible update in this repository. Preserve a checkpoint because the task may be handed off. Do not publish or deploy; separately state what evidence and authority a production gate would still require.
```

**Lead:** Perfect Code V2. **Support:** Evidence Research for release/advisory applicability, Continuity & Recovery for the handoff, and Risk & Change Assurance for the separate production boundary. Research does not choose the deployment gate; engineering completion does not grant authorization.
