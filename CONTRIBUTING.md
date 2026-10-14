# Contributing

Preserve four distinct owners, proportional activation, canonical identities, and authoritative SKILL.md contracts. Do not introduce a fifth orchestrator or weaken an evaluator to pass.

Report the component, host/surface/version, OS, PowerShell version, and smallest safe reproduction. Separate observation from inference. Exclude credentials, personal paths, private data, transcripts and local backups. Use [private security reporting](SECURITY.md) for vulnerabilities.

## One deterministic gate

Prerequisites: Windows PowerShell 5.1 or PowerShell 7, the complete checkout/archive, and ordinary system-temp access. No Pester, Python, unpublished validator, account or network dependency is required.

~~~powershell
.\scripts\validate.ps1
# Explicitly exercise both installed runtimes:
powershell.exe -NoProfile -NonInteractive -File .\scripts\validate.ps1
pwsh.exe -NoProfile -NonInteractive -File .\scripts\validate.ps1
~~~

The gate prints its real runtime and validates exact package inventory/hashes, known frontmatter/metadata, both cases/evals collection shapes, unique IDs/queries, local links, PowerShell syntax, integrated-rule frontmatter, selected evaluation definitions and blank report completeness, existing smoke tests, hardening/fault tests, demo oracles and [targeted correction regressions](tests/correction-tests.ps1). Terminating failures give a nonzero process exit code. Final PASS is deterministic validation only.

The -StructureOnly option omits filesystem regression tests and is not the full gate. The metadata check covers the package's restricted known format, not general YAML or security scanning. Tests create uniquely named temporary fixtures, validate cleanup targets and do not traverse junctions during hardening cleanup. Never substitute a real project or global configuration as a test target.

## Behavioral evidence and review

Follow [the evaluation protocol](docs/evaluation.md). Parser success, reference-answer success and repeating skill vocabulary are not model compliance. Preserve existing case IDs, semantics and both collection shapes.

Synthetic PASS/FAIL objects in validator tests exercise schema/accounting only; they are not actual model outputs, attempts or behavioral results. BLOCKED and NOT RUN do not increase executed/completed counts.

For a skill change, reproduce the defect, make the smallest correction, update only relevant scenarios, run the gate, and disclose actual model trials or NOT RUN. A tooling-only repair must not change cores.

Keep PRs focused; include affected files, executed commands/results, runtime, security-sensitive changes and residuals. Run git diff --check. Do not commit generated logs/reports/backups or private data.

The prepared Windows CI uses powershell/pwsh, read-only repository permissions and a pinned official checkout action. Hosted results remain pending until reviewed code is pushed. See [compatibility](docs/compatibility.md).

Contributions are distributed under the [MIT license](LICENSE). Local PASS grants neither publication nor production authority.
