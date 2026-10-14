# Release preparation

The initial public snapshot is commit 960bedb46cd4098494b772aad2250b70d08decdc. On 2026-10-14 the repository had **no tags or GitHub Releases**. Its original 1.0.0 changelog label was not a published version tag. This hardening patch is local/unreleased.

A reviewed historical source can be obtained separately:

~~~powershell
git clone https://github.com/SadinKai/fix-antigravity.git fix-antigravity-review
git -C .\fix-antigravity-review switch --detach 960bedb46cd4098494b772aad2250b70d08decdc
~~~

That is the **old snapshot**, not these unpublished repairs. Future instructions must use an actually approved commit/version, not an invented tag. No release command is executed by validation.

## Owner checklist

1. Review the local diff/residuals; exclude credentials, private reports, transcripts, machine paths and backups.
2. Reconfirm all 43 canonical paths/hashes and unchanged integrated contract. Preserve /skills/** -text. Check exact committed/archive bytes, not only checkout bytes.
3. Run the full [gate](../CONTRIBUTING.md) in supported shells; record versions, failures and unavailable scanners.
4. Review [behavioral evidence](evaluation.md). NOT RUN stays NOT RUN; fixture tests are not model pass percentages.
5. Obtain explicit approval for the **new exact commit**. Earlier SHA approval does not authorize this patch.
6. Only under separate publication authority: commit/push without rewriting history, wait for actual hosted CI, inspect live SHA/tree and investigate failures.
7. Approve a version/tag/Release, attach truthful notes and checksum scope, and verify archive parity.
8. Publish tested compatibility, residuals and [update/restoration steps](installation.md).

GitHub already provides [tag-based releases/source archives](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases); no distribution service is needed.

## Draft notes — unreleased

Release-engineering hardening adds compatible preview, exact inventory checking, verified per-destination recovery outside selected/documented discovery layouts, bounded lossless manifest merging, validation/CI preparation and a tiny demonstration. Additional custom indexing requires owner review. Four skill cores and routing semantics are unchanged.

Version, new commit and hosted-run link remain unassigned. Do not claim general model reliability, comparative improvement, automatic activation, cross-platform automation or transactional multi-target installation.

## Metadata recommendation only

Suggested description: Four opt-in Antigravity skills for repository-grounded coding, sourced research, task recovery and consequential-change review. Existing relevant topics can stay; add antigravity-cli only alongside maintained compatibility evidence. No remote description/topic setting is changed by this patch.
