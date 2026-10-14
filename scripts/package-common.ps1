# Shared, dependency-free release tooling. Dot-source; never writes on import.
Set-StrictMode -Version Latest
$script:StackPackages = @('perfect-code-v2', 'evidence-research', 'continuity-recovery', 'risk-change-assurance')
$script:StackUtf8ByteLimit = 1048576

function Get-StackHash {
    param([Parameter(Mandatory)][string]$Path)
    $Path = Get-StackFullPath $Path
    # Get-FileHash in Windows PowerShell 5.1 calls provider property retrieval,
    # which inherits WhatIf and can return no object. Direct read-only .NET I/O
    # avoids that provider side effect without changing WhatIfPreference.
    $stream = [IO.File]::Open($Path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::Read)
    $sha = [Security.Cryptography.SHA256]::Create()
    try { return ([BitConverter]::ToString($sha.ComputeHash($stream))).Replace('-', '').ToLowerInvariant() }
    finally { $stream.Dispose(); $sha.Dispose() }
}

function Get-StackFullPath {
    param([Parameter(Mandatory)][string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path) -or $Path.IndexOfAny([IO.Path]::GetInvalidPathChars()) -ge 0) { throw 'Invalid filesystem path.' }
    if ($Path.StartsWith('\\?\') -or $Path.StartsWith('\\.\')) { throw 'Device/extended path aliases are not supported.' }
    # Windows GetFullPath can erase trailing dots/spaces. Reject the original
    # spelling before normalization, otherwise source-overlap checks can alias.
    $parts = $Path -split '[\\/]'
    for ($i = 0; $i -lt $parts.Count; $i++) {
        $part = $parts[$i]
        if ($part -in @('', '.', '..') -or ($i -eq 0 -and $part -match '^[A-Za-z]:$')) { continue }
        if ($part.EndsWith('.') -or $part.EndsWith(' ') -or $part -match '[:*?\[\]"<>|]' -or $part -match '^(CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])(\.|$)') { throw 'Ambiguous/unsafe filesystem path segment.' }
    }
    try {
        # PowerShell's location can differ from Environment.CurrentDirectory.
        # Resolve nonexistent paths through the caller's provider before .NET I/O.
        $provider = $null; $drive = $null
        $resolved = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path, [ref]$provider, [ref]$drive)
        if ($provider.Name -ne 'FileSystem') { throw 'Not a FileSystem provider path.' }
        $full = [IO.Path]::GetFullPath($resolved)
    }
    catch { throw 'Invalid filesystem path; a FileSystem provider location is required.' }
    if ($full.Length -eq [IO.Path]::GetPathRoot($full).Length) { return $full }
    return $full.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
}

function Test-StackWithin {
    param([string]$Path, [string]$Root)
    $p = Get-StackFullPath $Path
    $r = Get-StackFullPath $Root
    return $p.Equals($r, [StringComparison]::OrdinalIgnoreCase) -or $p.StartsWith($r.TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)
}

function Assert-StackNoLink {
    param([Parameter(Mandatory)][string]$Path)
    $cursor = Get-StackFullPath $Path
    while (-not [string]::IsNullOrEmpty($cursor)) {
        $attributes = $null
        try { $attributes = [IO.File]::GetAttributes($cursor) }
        catch [IO.FileNotFoundException] { }
        catch [IO.DirectoryNotFoundException] { }
        if ($null -ne $attributes) {
            # GetAttributes inspects the link itself, even when its target is
            # missing. Test-Path alone can misclassify dangling links as absent.
            if (($attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { throw "Links/junctions are not followed: $cursor" }
            $item = Get-Item -LiteralPath $cursor -Force -ErrorAction Stop
            $linkType = $item.PSObject.Properties['LinkType']
            if ($null -ne $linkType -and $linkType.Value -eq 'HardLink') { throw "Hard links are not accepted: $cursor" }
        }
        $parent = [IO.Path]::GetDirectoryName($cursor.TrimEnd('\', '/'))
        if ($parent -eq $cursor) { break }
        $cursor = $parent
    }
}

function Assert-StackRelativePath {
    param([Parameter(Mandatory)][string]$Path)
    # The canonical packages use portable ASCII names. Refuse ambiguous Windows
    # spellings, ADS, wildcard characters, device names, and alternate separators.
    if ($Path -cnotmatch '^[A-Za-z0-9._-]+(/[A-Za-z0-9._-]+)*$') { throw "Unsafe package path: $Path" }
    foreach ($part in $Path.Split('/')) {
        if ($part -in @('.', '..') -or $part.EndsWith('.') -or $part -match '^(CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])(\.|$)') { throw "Unsafe package path: $Path" }
    }
}

function Read-StackUtf8 {
    param([Parameter(Mandatory)][string]$Path)
    $Path = Get-StackFullPath $Path
    Assert-StackNoLink $Path
    if (([IO.FileInfo]::new($Path)).Length -gt $script:StackUtf8ByteLimit) { throw "Input exceeds the supported 1 MiB limit (1048576 encoded bytes, including BOM): $Path" }
    $bytes = [IO.File]::ReadAllBytes($Path)
    if ($bytes.Length -gt $script:StackUtf8ByteLimit) { throw "Input exceeds the supported 1 MiB limit (1048576 encoded bytes, including BOM): $Path" }
    $bom = $bytes.Length -ge 3 -and $bytes[0] -eq 239 -and $bytes[1] -eq 187 -and $bytes[2] -eq 191
    $offset = if ($bom) { 3 } else { 0 }
    $encoding = New-Object Text.UTF8Encoding($false, $true)
    try { $value = $encoding.GetString($bytes, $offset, $bytes.Length - $offset) }
    catch { throw "Input must be valid UTF-8 (optional UTF-8 BOM): $Path" }
    return [pscustomobject]@{ Text = $value; Bom = $bom }
}

function ConvertTo-StackUtf8Bytes {
    param([Parameter(Mandatory)][AllowEmptyString()][string]$Text, [bool]$Bom = $false)
    $encoding = New-Object Text.UTF8Encoding($Bom, $true)
    $preamble = $encoding.GetPreamble()
    $length = [long]$encoding.GetByteCount($Text) + $preamble.Length
    if ($length -gt $script:StackUtf8ByteLimit) { throw "Encoded output exceeds the supported 1 MiB limit: $length bytes; maximum 1048576, including BOM. No writes permitted." }
    $payload = $encoding.GetBytes($Text)
    if ($preamble.Length -eq 0) { return ,$payload }
    $bytes = New-Object byte[] $length
    [Buffer]::BlockCopy($preamble, 0, $bytes, 0, $preamble.Length)
    [Buffer]::BlockCopy($payload, 0, $bytes, $preamble.Length, $payload.Length)
    return ,$bytes
}

function Get-StackInventory {
    param([Parameter(Mandatory)][string]$Root)
    $Root = Get-StackFullPath $Root
    Assert-StackNoLink $Root
    if (-not (Test-Path -LiteralPath $Root -PathType Container)) { throw "Package directory missing: $Root" }
    $base = Get-StackFullPath $Root
    $files = [Collections.Generic.Dictionary[string,string]]::new([StringComparer]::OrdinalIgnoreCase)
    $dirs = [Collections.Generic.Dictionary[string,string]]::new([StringComparer]::OrdinalIgnoreCase)
    $pending = [Collections.Generic.Stack[string]]::new()
    $pending.Push($base)
    while ($pending.Count -gt 0) {
        # Do not use -Recurse: examine each entry before descending into it.
        foreach ($item in Get-ChildItem -LiteralPath $pending.Pop() -Force -ErrorAction Stop) {
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { throw "Links/junctions are not followed: $($item.FullName)" }
            $linkType = $item.PSObject.Properties['LinkType']
            if ($null -ne $linkType -and $linkType.Value -eq 'HardLink') { throw "Hard links are not accepted: $($item.FullName)" }
            $relative = $item.FullName.Substring($base.Length + 1).Replace('\', '/')
            if ($files.ContainsKey($relative) -or $dirs.ContainsKey($relative)) { throw "Case/path collision: $relative" }
            if ($item.PSIsContainer) { $dirs.Add($relative, $relative); $pending.Push($item.FullName) }
            else { $files.Add($relative, (Get-StackHash $item.FullName)) }
        }
    }
    return [pscustomobject]@{ Files = $files; Directories = $dirs }
}

function Read-StackChecksums {
    param([Parameter(Mandatory)][string]$Path)
    $map = [Collections.Generic.Dictionary[string,string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach ($line in (Read-StackUtf8 $Path).Text -split '\r?\n') {
        if ($line -eq '') { continue }
        if ($line -cnotmatch '^([0-9a-fA-F]{64})  skills/(.+)$') { throw 'Malformed checksum entry; expected SHA-256, two spaces, skills/relative-path.' }
        $hash = $Matches[1].ToLowerInvariant(); $relative = $Matches[2]
        Assert-StackRelativePath $relative
        if ($script:StackPackages -cnotcontains $relative.Split('/')[0]) { throw "Unknown package in checksum manifest: $relative" }
        if ($map.ContainsKey($relative)) { throw "Duplicate/colliding checksum path: $relative" }
        $map.Add($relative, $hash)
    }
    if ($map.Count -ne 43) { throw "Expected exactly 43 package checksums; found $($map.Count)." }
    foreach ($name in $script:StackPackages) {
        foreach ($required in @('SKILL.md', 'agents/openai.yaml', 'evals/evals.json', 'evals/trigger_evals.json', 'evals/BENCHMARK.md')) {
            if (-not $map.ContainsKey("$name/$required")) { throw "Required package path missing from manifest: $name/$required" }
        }
    }
    return ,$map
}

function Assert-StackInventory {
    param([Parameter(Mandatory)][string]$Root, [Parameter(Mandatory)]$Expected)
    $actual = Get-StackInventory $Root
    if ($actual.Files.Count -ne $Expected.Count) { throw "Package inventory count mismatch: expected $($Expected.Count), found $($actual.Files.Count)." }
    $expectedDirs = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach ($path in $Expected.Keys) {
        if (@($actual.Files.Keys) -cnotcontains $path -or $actual.Files[$path] -cne $Expected[$path]) { throw "Missing, differently cased, or changed package file: $path" }
        $cursor = $path
        while ($cursor.Contains('/')) { $cursor = $cursor.Substring(0, $cursor.LastIndexOf('/')); $null = $expectedDirs.Add($cursor) }
    }
    foreach ($path in $actual.Files.Keys) { if (-not $Expected.ContainsKey($path)) { throw "Unexpected package file: $path" } }
    if ($expectedDirs.Count -ne $actual.Directories.Count) { throw 'Unexpected or missing package directory (including empty directories).' }
    foreach ($path in $actual.Directories.Keys) { if (-not $expectedDirs.Contains($path)) { throw "Unexpected package directory: $path" } }
}

function Get-StackPackageMap {
    param($Manifest, [string]$Name)
    $map = [Collections.Generic.Dictionary[string,string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach ($path in $Manifest.Keys) { if ($path.StartsWith($Name + '/', [StringComparison]::Ordinal)) { $map.Add($path.Substring($Name.Length + 1), $Manifest[$path]) } }
    return ,$map
}

function Get-StackBytesHash {
    param([byte[]]$Bytes)
    $sha = [Security.Cryptography.SHA256]::Create()
    try { return ([BitConverter]::ToString($sha.ComputeHash($Bytes))).Replace('-', '').ToLowerInvariant() }
    finally { $sha.Dispose() }
}

function Assert-StackRule {
    param([string]$Path)
    $text = (Read-StackUtf8 $Path).Text
    if ($text -notmatch '(?s)\A---\r?\n(.*?)\r?\n---\r?\n' -or $Matches[1] -notmatch '(?m)^trigger: always_on\r?$') { throw 'Integrated contract must retain valid always_on frontmatter.' }
}

function Get-StackSnapshot {
    param([Parameter(Mandatory)][string]$Path)
    $Path = Get-StackFullPath $Path
    Assert-StackNoLink $Path
    if (-not (Test-Path -LiteralPath $Path)) { return 'MISSING' }
    if (Test-Path -LiteralPath $Path -PathType Leaf) { return 'FILE:' + (Get-StackHash $Path) }
    $inventory = Get-StackInventory $Path
    $records = @('DIRECTORY') + @($inventory.Directories.Keys | Sort-Object | ForEach-Object { "D:$_" }) + @($inventory.Files.Keys | Sort-Object | ForEach-Object { "F:$_=$($inventory.Files[$_])" })
    return $records -join "`n"
}

function Read-StackYamlScalar {
    param([AllowEmptyString()][string]$Text)
    $textValue = $Text.Trim(' ', [char]9)
    if ($textValue.StartsWith('"')) {
        # Deliberately bounded YAML subset: quote/backslash escapes only.
        if ($textValue -cnotmatch '^"(?<value>(?:[^"\\\r\n]|\\["\\])*)"[ \t]*(?:#.*)?$') { throw 'Ambiguous or unsupported double-quoted candidate scalar.' }
        return [regex]::Replace($Matches['value'], '\\(["\\])', '$1')
    }
    if ($textValue.StartsWith("'")) {
        if ($textValue -cnotmatch "^'(?<value>(?:[^'\r\n]|'')*)'[ \t]*(?:#.*)?$") { throw 'Malformed single-quoted candidate scalar.' }
        return $Matches['value'].Replace("''", "'")
    }
    if ($textValue -match '^[#\[\]{}&*!|>@%'']' -or $textValue.StartsWith([string][char]96)) { throw 'Ambiguous or unsupported candidate scalar.' }
    $value = ($textValue -split '[ \t]+#', 2)[0].TrimEnd(' ', [char]9)
    if ([string]::IsNullOrWhiteSpace($value) -or $value -match ':[ \t]') { throw 'Empty or ambiguous candidate scalar.' }
    if ($value -match '^(null|~|true|false|yes|no|on|off)$|^[-+]?(?:[0-9]+(?:\.[0-9]*)?|\.[0-9]+)(?:[eE][-+]?[0-9]+)?$|^[-+]?0[xob][0-9a-f]+$|^[0-9]{4}-[0-9]{2}-[0-9]{2}(?:[Tt ].*)?$') { throw 'Implicitly typed candidate scalar requires explicit quoting/manual review.' }
    return $value
}

function Get-StackCandidateIdentity {
    param([string]$Path, [string]$FolderName)
    $text = (Read-StackUtf8 $Path).Text
    if ($text -cnotmatch '(?s)\A---[ \t]*\r?\n(?<front>.*?)\r?\n---[ \t]*(?:\r?\n|\z)') { throw "Missing/malformed candidate frontmatter requires manual review: $FolderName" }
    $front = $Matches['front']
    $fields = [Collections.Generic.Dictionary[string,string]]::new([StringComparer]::Ordinal)
    $block = $false
    $blockHasContent = $false
    foreach ($line in ($front -split '\r?\n')) {
        if ($line -match '^[ \t]*(#.*)?$') { continue }
        if ($line -match '^[ \t]') {
            if ($block) { $blockHasContent = $true; continue }
            throw "Nested/indented candidate metadata requires manual review: $FolderName"
        }
        if ($block -and -not $blockHasContent) { throw "Empty candidate block scalar: $FolderName" }
        $block = $false
        if ($line -cnotmatch '^(?<key>[A-Za-z_][A-Za-z0-9_-]*)[ \t]*:[ \t]*(?<value>.*)$') { throw "Unsupported candidate mapping requires manual review: $FolderName" }
        $key = $Matches['key']; $rawValue = $Matches['value']
        if ($fields.ContainsKey($key) -or ($key -ieq 'name' -and $key -cne 'name')) { throw "Ambiguous candidate identity/mapping: $FolderName" }
        if ($key -cne 'name' -and $rawValue -match '^[|>][+-]?[ \t]*(#.*)?$') {
            $fields.Add($key, '<block scalar>'); $block = $true; $blockHasContent = $false
        }
        else { $fields.Add($key, (Read-StackYamlScalar $rawValue)) }
    }
    $identity = if ($fields.ContainsKey('name')) { $fields['name'] } else { $FolderName }
    if ($identity -cnotmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$') { throw "Invalid candidate identity; manual review required: $FolderName" }
    # Recognized legacy copies remain duplicates even if other metadata is absent.
    if ($script:StackPackages -contains $identity -and $FolderName -cne $identity) { throw "Duplicate skill candidate requires manual review; not moved or deleted: $FolderName" }
    if ($block -and -not $blockHasContent) { throw "Empty candidate block scalar: $FolderName" }
    if (-not $fields.ContainsKey('description') -or [string]::IsNullOrWhiteSpace($fields['description'])) { throw "Candidate description missing; manual review required: $FolderName" }
    return $identity
}

function Assert-StackUniqueSkills {
    param([string]$Root)
    $Root = Get-StackFullPath $Root
    if (-not (Test-Path -LiteralPath $Root -PathType Container)) { return }
    Assert-StackNoLink $Root
    foreach ($dir in Get-ChildItem -LiteralPath $Root -Directory -Force) {
        if ($script:StackPackages -ccontains $dir.Name) { continue }
        if (($dir.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { throw "Uninspected skill-root link requires manual review; not followed: $($dir.Name)" }
        $core = Join-Path $dir.FullName 'SKILL.md'
        if (Test-Path -LiteralPath $core -PathType Leaf) {
            $identity = Get-StackCandidateIdentity -Path $core -FolderName $dir.Name
            if ($script:StackPackages -contains $identity) { throw "Duplicate skill candidate requires manual review; not moved or deleted: $($dir.Name)" }
        }
    }
}

function Get-StackRecoveryRoot {
    param([string]$TargetRoot, [string]$RequestedRoot, [string[]]$OtherTargets)
    $TargetRoot = Get-StackFullPath $TargetRoot
    $OtherTargets = @($OtherTargets | ForEach-Object { Get-StackFullPath $_ })
    $root = if ($RequestedRoot) { Get-StackFullPath $RequestedRoot } else { Join-Path (Split-Path -Parent $TargetRoot) 'fix-antigravity-recovery' }
    $discoveryRoots = @($TargetRoot, (Join-Path $HOME '.gemini\config\skills'), (Join-Path $HOME '.gemini\antigravity-cli\skills'), (Join-Path $HOME '.gemini\antigravity\skills'))
    foreach ($target in (@($TargetRoot) + @($OtherTargets))) {
        $cursor = Get-StackFullPath $target
        while ($cursor) {
            if ([IO.Path]::GetFileName($cursor) -eq 'skills') { $discoveryRoots += $cursor }
            $discoveryRoots += (Join-Path $cursor '.agents\skills'), (Join-Path $cursor '.agent\skills')
            $cursor = Split-Path -Parent $cursor
        }
    }
    # Inspect recovery's own ancestry, not just the selected target's ancestry.
    # Match whole segments for documented workspace, global and CLI-plugin layouts.
    $cursor = $root
    while ($cursor) {
        if ([IO.Path]::GetFileName($cursor) -ieq 'skills') {
            $parent = Split-Path -Parent $cursor
            $grand = Split-Path -Parent $parent
            $great = if ($grand) { Split-Path -Parent $grand } else { '' }
            $above = if ($great) { Split-Path -Parent $great } else { '' }
            $parentName = [IO.Path]::GetFileName($parent)
            $globalLayout = $parentName -in @('config','antigravity-cli','antigravity') -and [IO.Path]::GetFileName($grand) -ieq '.gemini'
            $pluginLayout = [IO.Path]::GetFileName($grand) -ieq 'plugins' -and [IO.Path]::GetFileName($great) -ieq 'antigravity-cli' -and [IO.Path]::GetFileName($above) -ieq '.gemini'
            if ($parentName -in @('.agents','.agent') -or $globalLayout -or $pluginLayout) { $discoveryRoots += $cursor }
        }
        $cursor = Split-Path -Parent $cursor
    }
    foreach ($discovery in $discoveryRoots) { if (Test-StackWithin $root $discovery) { throw 'BackupRoot must be outside the selected and documented skill-discovery layouts; choose an explicit safe -BackupRoot.' } }
    foreach ($target in (@($TargetRoot) + @($OtherTargets))) {
        if ((Test-StackWithin $root $target) -or (Test-StackWithin $target $root)) { throw 'Recovery storage and active destinations must not overlap.' }
    }
    Assert-StackNoLink $root
    return $root
}

function Get-StackManifestPaths {
    param([string]$SkillRoot)
    $SkillRoot = Get-StackFullPath $SkillRoot
    $default = Get-StackFullPath (Join-Path $HOME '.gemini\config\skills')
    foreach ($name in $script:StackPackages) {
        if ($SkillRoot.Equals($default, [StringComparison]::OrdinalIgnoreCase)) { "~/.gemini/config/skills/$name" }
        else { (Join-Path $SkillRoot $name).Replace('\', '/') }
    }
}

function Invoke-StackReplacement {
    param(
        [string]$Source, [byte[]]$Bytes, [Parameter(Mandatory)][string]$Destination,
        [Parameter(Mandatory)][string]$RecoveryRoot, [Parameter(Mandatory)][string]$OriginalSnapshot,
        [Parameter(Mandatory)][string]$NewSnapshot, [scriptblock]$FaultInjector
    )
    $Destination = Get-StackFullPath $Destination
    $RecoveryRoot = Get-StackRecoveryRoot -TargetRoot $Destination -RequestedRoot $RecoveryRoot -OtherTargets @()
    if ($Source) { $Source = Get-StackFullPath $Source }
    # FaultInjector is a helper-level test seam, never an installer CLI option.
    $operationRoot = Join-Path $RecoveryRoot (([IO.Path]::GetFileName($Destination)) + '.' + (Get-Date -Format 'yyyyMMddTHHmmssfff') + '.' + [Guid]::NewGuid().ToString('N'))
    $stage = Join-Path $operationRoot 'staged'
    $backup = Join-Path $operationRoot 'backup'
    $previous = Join-Path $operationRoot 'previous'
    $deactivated = $false
    $activationAttempted = $false
    try {
        Assert-StackNoLink $Destination
        Assert-StackNoLink $RecoveryRoot
        if ((Get-StackSnapshot $Destination) -cne $OriginalSnapshot) { throw 'Destination changed after preflight; refusing replacement.' }
        $null = New-Item -ItemType Directory -Path $operationRoot -ErrorAction Stop
        if ($FaultInjector) { & $FaultInjector 'StageCopy' $stage }
        if ($Source) { Copy-Item -LiteralPath $Source -Destination $stage -Recurse -Force -ErrorAction Stop }
        else { [IO.File]::WriteAllBytes($stage, $Bytes) }
        if ($FaultInjector) { & $FaultInjector 'StageVerify' $stage }
        if ((Get-StackSnapshot $stage) -cne $NewSnapshot) { throw 'Staged replacement verification failed.' }
        if ($OriginalSnapshot -cne 'MISSING') {
            if ($FaultInjector) { & $FaultInjector 'BackupCopy' $backup }
            Copy-Item -LiteralPath $Destination -Destination $backup -Recurse -Force -ErrorAction Stop
            if ($FaultInjector) { & $FaultInjector 'BackupVerify' $backup }
            if ((Get-StackSnapshot $backup) -cne $OriginalSnapshot) { throw 'Backup verification failed; active destination not replaced.' }
        }
        $receipt = [ordered]@{ destination = $Destination; backup = if ($OriginalSnapshot -cne 'MISSING') { 'backup' } else { $null }; createdUtc = [DateTime]::UtcNow.ToString('o'); originalSnapshot = $OriginalSnapshot; replacementSnapshot = $NewSnapshot }
        [IO.File]::WriteAllText((Join-Path $operationRoot 'restore-info.json'), ($receipt | ConvertTo-Json -Depth 4), (New-Object Text.UTF8Encoding($false)))
        if ((Get-StackSnapshot $Destination) -cne $OriginalSnapshot) { throw 'Destination changed during staging; refusing activation.' }
        if ($OriginalSnapshot -cne 'MISSING') {
            if ($FaultInjector) { & $FaultInjector 'Deactivate' $Destination }
            Move-Item -LiteralPath $Destination -Destination $previous -ErrorAction Stop
            $deactivated = $true
        }
        $parent = Split-Path -Parent $Destination
        if (-not (Test-Path -LiteralPath $parent)) { $null = New-Item -ItemType Directory -Path $parent -Force -ErrorAction Stop }
        $activationAttempted = $true
        if ($FaultInjector) { & $FaultInjector 'Activate' $Destination }
        Move-Item -LiteralPath $stage -Destination $Destination -ErrorAction Stop
        if ($FaultInjector) { & $FaultInjector 'ActivationVerify' $Destination }
        if ((Get-StackSnapshot $Destination) -cne $NewSnapshot) { throw 'Activated replacement verification failed.' }
        Write-Host "Installed: $Destination"
        if ($OriginalSnapshot -cne 'MISSING') { Write-Host "Verified recovery copy: $backup (restore-info.json names its target)" }
    }
    catch {
        $failure = $_.Exception.Message
        $recovery = 'No active content was intentionally removed.'
        try {
            # Inspect actual effects, including operations that mutated then threw.
            $current = Get-StackSnapshot $Destination
            if ($current -ceq $OriginalSnapshot) { $recovery = 'Original active state verified unchanged.' }
            elseif ($activationAttempted -or $deactivated -or (Test-Path -LiteralPath $previous)) {
                if ($current -cne 'MISSING') {
                    if ($current -cne $NewSnapshot) { throw 'Unexpected active content preserved; automatic restoration would overwrite it.' }
                    Move-Item -LiteralPath $Destination -Destination (Join-Path $operationRoot 'failed-activation') -ErrorAction Stop
                }
                if ($OriginalSnapshot -cne 'MISSING') {
                    if ($FaultInjector) { & $FaultInjector 'Restore' $Destination }
                    if (Test-Path -LiteralPath $previous) { Move-Item -LiteralPath $previous -Destination $Destination -ErrorAction Stop }
                    elseif ((Get-StackSnapshot $backup) -ceq $OriginalSnapshot) { Copy-Item -LiteralPath $backup -Destination $Destination -Recurse -Force -ErrorAction Stop }
                    else { throw 'No verified restoration source is available.' }
                }
                if ($FaultInjector) { & $FaultInjector 'RestoreVerify' $Destination }
                if ((Get-StackSnapshot $Destination) -cne $OriginalSnapshot) { throw 'Restoration verification failed.' }
                $recovery = 'Original active state restored and verified.'
            }
            else { $recovery = 'Destination diverged; preserved for manual reconciliation.' }
        }
        catch { $recovery = "RESTORATION NOT VERIFIED: $($_.Exception.Message)" }
        throw "Replacement failed: $failure $recovery Recovery artifacts (inspect before restoring): $operationRoot. Earlier successful package operations, if any, are not rolled back."
    }
}
