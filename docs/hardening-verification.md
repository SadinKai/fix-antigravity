# Hardening verification

## Current final corrections — 2026-10-14

Local unpublished patch on top of 960bedb46cd4098494b772aad2250b70d08decdc.
**Local deterministic requalification: PASS WITH EXTERNAL RESIDUALS; ready for owner review only.**
No publication, hosted-CI, discovery or live-model approval is implied.

### Executed final matrix

Actual command: scripts/validate.ps1 in each runtime/tree. Fresh copies contained all 82 non-ignored project files with byte parity and no Git metadata or private evidence dependency.

| Tree | PowerShell version | Distinct cases | Executions | Passed | Failed | Skipped |
|---|---|---:|---:|---:|---:|---:|
| Working tree | 5.1.26100.9444 | 163 | 163 | 163 | 0 | 0 |
| Working tree | 7.6.5 | 163 | 163 | 163 | 0 | 0 |
| Fresh copy, no Git/private resources | 5.1.26100.9444 | 163 | 163 | 163 | 0 | 0 |
| Fresh copy, no Git/private resources | 7.6.5 | 163 | 163 | 163 | 0 | 0 |

**163 distinct cases repeated across four cells = 652 executions; 652 passed, 0 failed, 0 skipped.**
Every cell retains 7 existing smoke + 73 existing hardening + 2 demo cases (the original 82), and adds 81 correction regressions. Original smoke/hardening/demo assertions were not weakened or replaced.
The previous 328 executions were 82 distinct cases repeated across four cells, not 328 independent cases. Development/intermediate runs are excluded from the final totals above.

Correction-suite categories per cell:

| Category | Passed | Failed |
|---|---:|---:|
| path resolution | 10 | 0 |
| recovery isolation | 14 | 0 |
| candidate identity | 24 | 0 |
| manifest bytes | 8 | 0 |
| report states | 21 | 0 |
| template gate | 3 | 0 |
| cleanup safety | 1 | 0 |

Separate full-run structural evidence: 19 groups, 43 canonical files, 258 behavioral/106 trigger definitions, 80 resolving relative Markdown links, 14 PowerShell parse checks and 12 selected trial definitions plus blank report completeness. Definitions and synthetic schema fixtures are not executed model trials.

### Five corrected defects and observed regressions

| Defect | Precise correction | Actual evidence on both runtimes |
|---|---|---|
| Relative filesystem paths | One provider-aware resolver uses PowerShell's current filesystem location before .NET normalization. Installer/verifier, snapshots, hashing, staging/recovery and fixture cleanup consume absolute normalized paths. | With process cwd deliberately different: safe existing/nonexistent/dot-segment targets installed at the intended location; unrelated native-cwd data stayed unchanged. Source equality/ancestor/descendant/dot aliases were rejected with complete fixture snapshots unchanged. Relative rule/manifest/recovery paths verified correctly. Variable-provider relative input failed before writes. |
| Recovery placement | Validate the recovery path's own ancestry against whole-segment documented workspace, global, legacy and CLI-plugin layouts, plus selected destinations/skills ancestors; replacement helper rechecks before staging. | Six documented layouts, equality, case and normalized dot aliases rejected before writes with active/configuration/rule/prior-recovery state preserved. Legitimate/substr-name controls installed and retained a verified prior package. Injected abandoned staging stayed outside the selected skill root. No activation claim. |
| Duplicate identity | Bounded frontmatter/scalar reader recognizes plain/single/double quotes and comments outside scalars, handles supported escapes and folder defaults, and fails closed on unsupported/ambiguous metadata. | Five-directory duplicates rejected for five spellings by installer and verifier, with complete fixture state unchanged. Fifteen malformed/ambiguous inputs rejected; unrelated quoted/block/default identities accepted and retained. Quoted hashes/escapes preserved. The legacy duplicate fixture still raises duplicate detection even with incomplete ancillary metadata. |
| Manifest byte boundary | Shared 1,048,576-byte UTF-8 file limit includes BOM. Final merged/encoded bytes are preflighted before all requested operations and the same byte array is hashed/staged/written. | Exactly 1,048,576 bytes accepted, verified and idempotent with/without BOM; 1,048,577 bytes rejected with the whole package/rule/configuration/recovery fixture unchanged. The reported 1,048,514-byte Unicode input rejected before writes. Tiny JSON expanding through 5,500 generic helper registrations rejected (installer still requests four). Strict encoding failure preserved state; a real sharing violation preserved original manifest and verified backup. |
| Honest BLOCKED reports | Separate NOT RUN, pre-execution BLOCKED and complete reported PASS/FAIL; require structured blocker observations and typed provenance/evidence. Preserve string dates where the runtime supports DateKind and accept JSON integer exit codes across runtimes. | Blank report counted 0 executed/completed and 12 unrun. Honest blocker counted 1 blocked, 11 unrun, 0 executed/completed without inventing date/output/run ID. Mixed synthetic report counted only its two executed fixtures. Contradictory/incomplete records and array-valued discriminators/digests rejected. Owner/configuration/command/artifact evidence shapes exercised. No actual model trial occurred. |

### Optional template gate and cleanup

The main gate now reuses evaluate.ps1's report-completeness implementation. The real template passes; malformed and incomplete temporary copies fail the main structural gate without state changes. Additional subprocess checks returned exit 1 for malformed templates on both runtimes; these diagnostics are not added to the 163-case count.

Cleanup regression refused a separate generated sentinel fixture and removed only the in-root junction, preserving the sentinel's bytes. All installer/configuration/recovery test writes were confined to generated temporary fixtures. No real user manifest or installed global skill root was used as a test target.

Development exposed a test-runner variable collision and differing JSON integer types (19 initial correction-case failures), plus the legacy duplicate diagnostic boundary in the old suite. These were corrected without weakening existing assertions. The final frozen code/test matrix above passed; no code/test edits occurred during it. This report was updated afterward, and final structural checks were rerun on the reported tree.

### Integrity and scope

Before editing, all 43 protected paths/SHA-256 values were saved from the actual checkout and compared with the canonical four-package source and published Git blobs. A separate private byte copy preserved all 81 pre-existing project files and their reviewed unpublished changes.

Before/after: **43 present, 0 missing, 0 extra, 0 changed**; canonical source parity 43/43; original published blob parity 43/43.
No skill core, protected evaluator definition, metadata, identity or integrated-contract semantics changed.

Checksum manifest SHA-256: 45c2028e655b6ac7b0af1ce2e046bbe1354737e3dcea36a1f2fb7e4ca1fcc106

Integrated contract SHA-256: 20b5d9a8f8998126c0358aca80e5d3e78078a6f39ee4e52bfc44ca72c481b533

This correction pass updates 16 existing files and adds 1 file:

```text
docs/compatibility.md
docs/evaluation.md
docs/hardening-verification.md
docs/releases.md
evals/report-template.json
scripts/evaluate.ps1
scripts/manifest-json.ps1
scripts/package-common.ps1
scripts/validate.ps1
tests/test-support.ps1
CHANGELOG.md
CONTRIBUTING.md
README.md
docs/installation.md
scripts/install.ps1
scripts/verify-install.ps1
tests/correction-tests.ps1 (new)
```

Complete unpublished patch inventory: 12 modified tracked files + 20 untracked additions; no deletions or staged changes:

```text
 M .github/ISSUE_TEMPLATE/bug_report.yml
 M CHANGELOG.md
 M CONTRIBUTING.md
 M README.md
 M SECURITY.md
 M docs/installation.md
 M docs/troubleshooting.md
 M docs/usage-guide.md
 M examples/example-workflows.md
 M scripts/install.ps1
 M scripts/verify-install.ps1
 M tests/install-smoke.ps1
?? .github/workflows/validate.yml
?? docs/compatibility.md
?? docs/evaluation.md
?? docs/hardening-verification.md
?? docs/releases.md
?? evals/fixtures.json
?? evals/report-template.json
?? evals/slice.json
?? examples/first-success/README.md
?? examples/first-success/fixture/recipients.ps1
?? examples/first-success/fixture/test.ps1
?? examples/first-success/reference-answer.ps1
?? scripts/evaluate.ps1
?? scripts/manifest-json.ps1
?? scripts/package-common.ps1
?? scripts/validate.ps1
?? tests/correction-tests.ps1
?? tests/demo-tests.ps1
?? tests/hardening-tests.ps1
?? tests/test-support.ps1
```

HEAD remains 960bedb46cd4098494b772aad2250b70d08decdc. No reset/clean/stash, dependency install, GitHub setting/API mutation, commit, push, tag, release or publication occurred in this pass. git diff --check passes. Unrelated pre-existing files remain byte-identical to the saved pre-edit copy.

### Remaining risks and checks not performed

- Filesystem checks are not a hostile-concurrent-substitution boundary. Stop competing writers.
- Recovery is per destination, not a multi-target transaction. Process interruption, real ACL/outage drills, ACL/alternate-stream preservation and cross-volume behavior remain unqualified.
- Recovery exclusions cover selected roots and documented layouts, not every custom indexing configuration. Unsupported/ambiguous candidate YAML requires manual review; no general YAML parser is claimed.
- Hosted CI, fresh live host indexing/activation, all 12 selected model trials and freshly executed full 258/106 model suites: **NOT RUN**. No API credits spent.
- Gitleaks, TruffleHog, detect-secrets, git-secrets and PSScriptAnalyzer were checked and are unavailable locally. No dedicated scanner PASS or clean security audit is asserted.
- A limited content-pattern diagnostic over 82 project files found no inspected credential/private-key/URL-credential patterns. One broad personal-path-pattern hit was generic slash-separated asset/user/tenant prose in the unchanged protected risk skill, not a personal path. This is not comprehensive scanning/history coverage.
- The earlier private-reporting API evidence below is historical; no GitHub settings were changed or requalified in this correction pass.

Verdict: **ready for owner review of this local patch**, with the external and operational limitations above. Not a publication authorization or universally safe-installer claim.

## Previous pre-correction hardening qualification — historical record

The following original report is retained as evidence for the earlier 82-case version. Its old totals, file inventory, remote-setting actions and PASS statements are historical, not fresh results for the current patch. The independent review found the five defects corrected above; the current section supersedes broader prior acceptance claims.

Date: 2026-10-14. Local unpublished patch on top of
960bedb46cd4098494b772aad2250b70d08decdc.

**Local deterministic qualification: PASS WITH EXTERNAL RESIDUALS.**
This is not hosted CI, live discovery, model compliance, or release authorization.

### Fresh final worktree runs

Command in each runtime: scripts/validate.ps1.

| Runtime | Existing smoke | Hardening regressions | Demo oracle scenarios | Failed | Skipped |
|---|---:|---:|---:|---:|---:|
| Windows PowerShell 5.1.26100.9444 | 7 | 73 | 2 | 0 | 0 |
| PowerShell 7.6.5 | 7 | 73 | 2 | 0 | 0 |

Each runtime executed 82 cases: 16 recovery/fault injection, 19 source-inventory,
15 local installation/preview, 20 manifest integration, 3 pure unit cases,
7 existing smoke scenarios and 2 demo scenarios. These are final qualification
counts, not cumulative development attempts. Initial development runs exposed
11 fault-injection assertions with incorrectly captured test closures; those
were repaired and the final injection stages actually executed. Additional
Windows alias tests exposed normalization erasing trailing dots/spaces; raw
spelling is now checked first and independent target fixtures pass.

Separate structural evidence per runtime: 19 groups, 43 package files,
8 canonical evaluator JSON files (258 behavioral / 106 trigger definitions),
78 resolving relative Markdown links, 13 PowerShell parse checks and 12 resolving
selected trial definitions. Definitions are not executed model tests.

Fresh-copy validation without Git metadata or private resources: **PASS on both
runtimes**, using an exact copy of all 81 non-ignored project files. No Python,
Pester, personal validator or Git metadata was required by the gate. Both trees
executed 82 cases per runtime: **328 final qualification scenario executions,
328 passed, 0 failed, 0 skipped**. This excludes earlier development iterations.

Supplemental independent check: 100 generated JSON inputs (seed 41, Unicode,
large integers and small numeric values) were merged by the PowerShell helper,
then compared semantically using existing Python 3.10 standard-library json with
Decimal parsing. **100/100 passed**; this diagnostic is not a model trial or a
project runtime dependency. Workflow YAML also parsed with existing PyYAML.

### Findings

| Finding | Local implementation/evidence | Remaining boundary |
|---|---|---|
| F1 | Direct read-only hashing; absent/valid/conflicting/repeated/checksum-invalid preview cases pass on both shells | Other runtime versions not individually qualified |
| F2 | Verified staged/backup/active/restored snapshots; stage, backup, activation, restoration, missing-source, denied-access and partial-effect fault tests | No real ACL/outage/kill-process rehearsal |
| F3 | New staging/backups outside discovery; upgrade has four intended directories; prior tree restored from backup | Live host indexing/selection NOT RUN |
| F4 | 19 invalid source fixtures fail before destination/recovery writes, including exact-content hard link/junction and hidden extras | Not a hostile concurrent-filesystem boundary |
| F5 | One repository-contained full gate; prepared pinned-action Windows matrix | Hosted CI NOT RUN |
| F6 | Eight existing behavioral cases plus four negative controls; inputs, rubrics and blank complete report | All 12 model trials NOT RUN |
| F7 | Seeded 2-pass/1-fail baseline and human-reference 3-pass repair; unchanged oracle | AI execution manual / NOT RUN |
| F8 | Empty objects, BOM variants, scalar/array/duplicate/malformed rejection, deep actual install and write-failure preservation | Strict UTF-8, 1 MiB, depth 64 limits; observed compatibility format only |
| F9 | Actual untagged state, acquisition/update/restoration and later release checklist documented | No new commit/tag/Release authorized or created |
| F10 | SadinKai admin confirmed; supported API PUT returned success; unauthenticated GET confirms enabled | No fabricated vulnerability submitted |

### Canonical baseline

43/43 package paths and SHA-256 values must remain identical to the saved baseline
and canonical source. No canonical contents, evaluator semantics, package names,
or integrated-contract semantics were changed.

Checksum-manifest SHA-256: 45c2028e655b6ac7b0af1ce2e046bbe1354737e3dcea36a1f2fb7e4ca1fcc106

Integrated-contract SHA-256: 20b5d9a8f8998126c0358aca80e5d3e78078a6f39ee4e52bfc44ca72c481b533

Final package comparison: **43 present, 0 missing, 0 extra, 0 changed**.
Canonical source parity: 43/43. Checksum manifest and integrated contract hashes
match the saved baseline exactly; Git reports no protected-path changes.

Canonical comparison covers the four package directories, not unrelated historical
reports stored beside them; those reports remain untouched and unpublished.
Final report text was updated after execution; structural/link checks were rerun.

### Acceptance and safety

Documentation: PASS for the local reviewed patch; public pages still reflect the
old commit until separately authorized publication. No pre-existing user changes
existed or were lost. Tests used only generated temporary fixtures, with
validated no-link cleanup. No real user configuration was used as a test target.
No dependency installation, commit, push, tag or Release occurred. Only the
explicitly authorized private-reporting setting changed remotely.

F1/F2/F4/F7/F8/F9 local outcomes: PASS. F3 layout/recovery: PASS, live discovery
NOT RUN. F5 local/fresh-copy gate: PASS, hosted CI NOT RUN. F6 protocol: PASS,
actual model evaluation NOT RUN. F10 live setting: PASS. Canonical integrity and
scope preservation: PASS. Overall qualification retains external residuals.

### Security and external checks

Limited content patterns over all 81 current non-ignored project files found
zero matches for inspected private-key, common provider-token, embedded URL
credential and personal-home-path patterns. This is not comprehensive scanning.

Gitleaks, TruffleHog, detect-secrets, git-secrets and PSScriptAnalyzer were
unavailable. No dependency manifest requiring a package vulnerability scanner
was introduced. Workflow YAML parsed using already-installed PyYAML as an
additional check; PyYAML is not required by the project gate.

Two hosted jobs are pending, live host discovery is NOT RUN, all 12 selected
model trials are NOT RUN, and the full 258/106 model suites were not rerun.
CLI 1.2.11 availability/help is not proof of safe model isolation or an approved
spending budget.

Only the specifically authorized private-reporting setting changed remotely.
Public main remains the original SHA; description/topics, tags and releases
were not changed. No commit or push occurred.

See [scope](compatibility.md), [evaluation](evaluation.md), and
[release checklist](releases.md).
