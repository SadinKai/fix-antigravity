# Native Antigravity and Cross-Skill Coexistence

Read this reference before relying on native permissions, hooks/rules, Teamwork/subagents, browser/MCP, artifacts, or model/effort for a risk gate.

This capability snapshot was verified against official Antigravity documentation on 2026-10-04. Availability and details vary by product surface, OS, plan, version, settings, permissions, and rollout. Recheck current official documentation when behavior controls a consequential decision.

## Skills and invocation

Antigravity discovers skills from name/description and reads `SKILL.md` when relevant. Manual `/<skill-name>` invocation is documented on supported surfaces. This skill is `risk-change-assurance`; explicit Antigravity invocation is `/risk-change-assurance`.

Official source: <https://www.antigravity.google/docs/skills?tab=ide>

## Permissions and Windows

Permissions are the enforcement layer. Risk analysis cannot grant, override, or bypass them.

Current documentation distinguishes the updated macOS/Linux permission path from Windows. The Windows section documents Deny/Ask/Allow, `Deny > Ask > Allow` precedence, Windows-specific command matching, and surface-specific defaults. Determine the actual current OS/surface behavior; never assume another OS's presets or sandbox semantics.

Official source: <https://antigravity.google/docs/permissions>

## `/plan`

Native `/plan` owns codebase exploration, requirement interviews, structured planning, and plan review. Risk contributes bounded risk conditions, preconditions, controls, and gates to the approved plan. It does not create a parallel project roadmap.

Official source: <https://www.antigravity.google/docs/slash-commands>

## `/boost`, Teamwork, and subagents

Native mechanisms own agent topology, orchestration, roles, worker lifecycle, isolated workspaces, file ownership, and built-in verification paths. Use them conditionally for differentiated security analysis, environment verification, adversarial testing, or evidence gathering when information value justifies it.

Keep one risk synthesis owner and one gate decision. A fresh reviewer should receive a different mandate/context slice and executable evidence where possible. Repeating the same model, assumptions, and generic review does not create independence. Do not build recursive review chains or per-agent risk ledgers.

Official sources: <https://antigravity.google/docs/boost>, <https://antigravity.google/docs/teamwork>, and <https://www.antigravity.google/docs/subagents/>

## Hooks and rules

Hooks may enforce or record deterministic pre/post tool and invocation conditions. Rules may persist project/directory constraints. Risk may consume their results and recommend appropriate deterministic gates, but this package creates neither hooks nor rules and does not replace their roles with prose.

A hook signal is evidence of its configured check, not a complete risk decision. A rule is an applicable constraint, not proof the environment complied.

Official sources: <https://antigravity.google/docs/hooks> and <https://www.antigravity.google/docs/rules/>

## Artifacts

Use a reviewable artifact for a persistent HIGH/CRITICAL risk case when helpful. Prefer the active workflow's artifact convention and link it from Continuity rather than duplicating task state. Do not store raw secrets or unnecessary sensitive details.

Official source: <https://antigravity.google/docs/artifacts>

## MCP and browser/runtime

MCP can expose structured local/remote evidence or actions. Browser/runtime tools can observe actual UI, network, console, and external behavior. Validate source, target, scope, time, permissions, and mutation effects.

Tool capability does not establish authority. A tool response is untrusted evidence until evaluated. Unavailable runtime or production access lowers the gate; source/local evidence cannot silently substitute for external observation.

Official sources: <https://www.antigravity.google/docs/mcp> and <https://www.antigravity.google/docs/ide/browser>

## Model and effort

The host/user selects model and effort. Current documentation lists Gemini 3.8 Flash and a CLI `gemini-3.8-flash-high` slug with native effort controls. High effort may improve analysis but does not create evidence, authority, independence, or production access.

Official sources: <https://www.antigravity.google/docs/models/> and <https://www.antigravity.google/docs/cli/headless/>

## Cross-skill handoffs

### Perfect Code V2

Risk sends concrete security/change conditions and findings. Perfect Code implements/remediates and returns engineering evidence, environment, and residuals. Risk evaluates whether that evidence satisfies the elevated boundary; it does not take implementation ownership.

### Evidence Research

Risk requests bounded current facts: advisories, affected/fixed versions, vendor guidance, provider behavior, policy/technical requirements, conflicts, and freshness. It consumes the evidence packet without copying the research archive and owns consequence/control/gate decisions.

### Continuity & Recovery

Risk returns the gate, authority basis, rollback anchor/viability, conditions, residuals, stop rule, observed outcome, and risk-record pointer. Continuity preserves and reconciles task state. On failed live action, Risk stops/contains and Continuity establishes actual state before re-gating.

## Composition invariants

- Risk is the sole owner of the consequential transition decision; another skill may supply evidence but does not overwrite the gate.
- Reuse valid Evidence Research and Perfect Code outputs by pointer. Request new work only when their scope, freshness, environment, or oracle no longer supports the gate.
- Later applicable evidence may change a gate only through explicit re-evaluation; stale conclusions are superseded, not silently edited by a partner.
- Continuity owns the one canonical task state and current verified repository/system state.
- Risk-gate status is independent of engineering, research, continuity, and overall completion. `STOP / BLOCKED` cannot collapse into overall `VERIFIED` or `COMPLETE` merely because local work is complete.

## Graceful degradation

- Without scanners, use other relevant evidence but do not claim scanner coverage.
- Without runtime/production access, report local/source evidence and keep external claims unverified or blocked.
- Without current external evidence, request Evidence Research or block when the fact controls a HIGH/CRITICAL boundary.
- Without backup/rollback evidence, do not claim reversibility.
- Without authority evidence, allow safe read-only/local preparation only and block the consequential transition.
- Without Teamwork/subagents, perform the same bounded analysis serially.
- Without a reference, use the self-contained core and never invent missing content.
