# Strict JSON syntax tree retaining original lexemes. No user data is reserialized.
# This bounded parser is for optional compatibility-manifest preservation, not YAML
# validation, a security scanner, or a new host manifest format.
class StackJsonReader {
    [string]$Text
    [int]$Position
    StackJsonReader([string]$text) { $this.Text = $text; $this.Position = 0 }
    [void] Space() { while ($this.Position -lt $this.Text.Length -and $this.Text[$this.Position] -in @(' ', "`t", "`r", "`n")) { $this.Position++ } }
    [string] StringValue() {
        $match = [regex]::Match($this.Text.Substring($this.Position), '^"(?:[^"\\\x00-\x1f]|\\(?:["\\/bfnrt]|u[0-9a-fA-F]{4}))*"')
        if (-not $match.Success) { throw 'Invalid JSON string.' }
        $this.Position += $match.Length
        $raw = $match.Value.Substring(1, $match.Length - 2)
        $decoded = [regex]::Replace($raw, '\\(u[0-9a-fA-F]{4}|["\\/bfnrt])', {
            param($m)
            switch ($m.Groups[1].Value) {
                'b' { return "`b" }; 'f' { return [string][char]12 }; 'n' { return "`n" }; 'r' { return "`r" }; 't' { return "`t" }
                default { if ($m.Groups[1].Value.StartsWith('u')) { return [string][char][Convert]::ToInt32($m.Groups[1].Value.Substring(1), 16) }; return $m.Groups[1].Value }
            }
        })
        for ($i = 0; $i -lt $decoded.Length; $i++) {
            if ([char]::IsHighSurrogate($decoded[$i])) { if ($i + 1 -ge $decoded.Length -or -not [char]::IsLowSurrogate($decoded[$i + 1])) { throw 'Unpaired Unicode surrogate.' }; $i++ }
            elseif ([char]::IsLowSurrogate($decoded[$i])) { throw 'Unpaired Unicode surrogate.' }
        }
        return $decoded
    }
    [object] Value([int]$depth) {
        if ($depth -gt 64) { throw 'JSON nesting exceeds supported depth 64; input not changed.' }
        $this.Space()
        if ($this.Position -ge $this.Text.Length) { throw 'Unexpected end of JSON.' }
        $start = $this.Position
        $members = [Collections.Generic.Dictionary[string,object]]::new([StringComparer]::Ordinal)
        $items = [Collections.Generic.List[object]]::new()
        $kind = ''; $value = $null
        $ch = $this.Text[$this.Position]
        if ($ch -eq '{' -or $ch -eq '[') {
            $kind = if ($ch -eq '{') { 'object' } else { 'array' }
            $close = if ($ch -eq '{') { '}' } else { ']' }
            $this.Position++; $this.Space()
            if ($this.Position -ge $this.Text.Length) { throw 'Unterminated JSON container.' }
            if ($this.Text[$this.Position] -ne $close) {
                while ($true) {
                    $this.Space()
                    if ($kind -eq 'object') {
                        $key = $this.StringValue(); $this.Space()
                        if ($this.Position -ge $this.Text.Length -or $this.Text[$this.Position] -ne ':') { throw 'Expected JSON colon.' }
                        $this.Position++
                        if ($members.ContainsKey($key)) { throw "Duplicate JSON object key: $key" }
                        $members.Add($key, $this.Value($depth + 1))
                    }
                    else { $items.Add($this.Value($depth + 1)) }
                    $this.Space()
                    if ($this.Position -ge $this.Text.Length) { throw 'Unterminated JSON container.' }
                    if ($this.Text[$this.Position] -eq $close) { break }
                    if ($this.Text[$this.Position] -ne ',') { throw 'Expected JSON comma.' }
                    $this.Position++
                }
            }
            $this.Position++
        }
        elseif ($ch -eq '"') { $kind = 'string'; $value = $this.StringValue() }
        else {
            $match = [regex]::Match($this.Text.Substring($this.Position), '^(?:true|false|null|-?(?:0|[1-9][0-9]*)(?:\.[0-9]+)?(?:[eE][+-]?[0-9]+)?)')
            if (-not $match.Success) { throw 'Invalid JSON value.' }
            $kind = 'literal'; $value = $match.Value; $this.Position += $match.Length
        }
        return [pscustomobject]@{ Kind = $kind; Value = $value; Start = $start; End = $this.Position; Raw = $this.Text.Substring($start, $this.Position - $start); Members = $members; Items = $items }
    }
}

function Read-StackJson {
    param([Parameter(Mandatory)][AllowEmptyString()][string]$Text)
    $null = ConvertTo-StackUtf8Bytes -Text $Text
    $reader = [StackJsonReader]::new($Text)
    $node = $reader.Value(0); $reader.Space()
    if ($reader.Position -ne $Text.Length) { throw 'Trailing content after JSON value.' }
    return $node
}

function Get-StackManifestKey {
    param([string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path) -or $Path -match '[\x00-\x1f]') { throw 'Manifest path must be a nonempty string without control characters.' }
    $value = $Path.Replace('\', '/')
    if ($value.StartsWith('~/')) { $value = (Join-Path $HOME $value.Substring(2)).Replace('\', '/') }
    # Normalize absolute local paths; leave unrelated relative registrations intact.
    if ([IO.Path]::IsPathRooted($value)) { $value = (Get-StackFullPath $value).Replace('\', '/') }
    return $value.TrimEnd('/').ToLowerInvariant()
}

function Assert-StackManifest {
    param($Node)
    if ($Node.Kind -cne 'object') { throw 'Manifest root must be a JSON object.' }
    $keys = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    if ($Node.Members.ContainsKey('entries')) {
        $entries = $Node.Members['entries']
        if ($entries.Kind -cne 'array') { throw 'Manifest entries must be a JSON array; no automatic repair is performed.' }
        foreach ($entry in $entries.Items) {
            if ($entry.Kind -cne 'object' -or -not $entry.Members.ContainsKey('path') -or $entry.Members['path'].Kind -cne 'string') { throw 'Every manifest entry must be an object with a string path.' }
            $key = Get-StackManifestKey $entry.Members['path'].Value
            if (-not $keys.Add($key)) { throw 'Duplicate/equivalent manifest paths are ambiguous; input not changed.' }
        }
    }
    return ,$keys
}

function Merge-StackManifest {
    param([Parameter(Mandatory)][string]$Text, [Parameter(Mandatory)][string[]]$Paths)
    $original = Read-StackJson $Text
    $keys = Assert-StackManifest $original
    $added = @()
    foreach ($path in $Paths) { if ($keys.Add((Get-StackManifestKey $path))) { $added += ([ordered]@{ path = $path } | ConvertTo-Json -Compress) } }
    if ($added.Count -eq 0) { return [pscustomobject]@{ Text = $Text; Changed = $false } }
    if ($original.Members.ContainsKey('entries')) {
        $entries = $original.Members['entries']
        $prefix = if ($entries.Items.Count -gt 0) { ',' } else { '' }
        $mergedText = $Text.Insert($entries.End - 1, $prefix + ($added -join ','))
    }
    else {
        $prefix = if ($original.Members.Count -gt 0) { ',' } else { '' }
        $mergedText = $Text.Insert($original.End - 1, $prefix + '"entries":[' + ($added -join ',') + ']')
    }
    $merged = Read-StackJson $mergedText
    $null = Assert-StackManifest $merged
    # Semantic round trip, with stronger exact-lexeme preservation for every
    # unrelated subtree and existing entry (including large numbers and dates).
    foreach ($key in $original.Members.Keys) {
        if ($key -ceq 'entries') {
            $oldItems = $original.Members[$key].Items; $newItems = $merged.Members[$key].Items
            if ($newItems.Count -ne $oldItems.Count + $added.Count) { throw 'Manifest entry preservation failed.' }
            for ($i = 0; $i -lt $oldItems.Count; $i++) { if ($oldItems[$i].Raw -cne $newItems[$i].Raw) { throw 'Existing manifest entry changed during round trip.' } }
        }
        elseif (-not $merged.Members.ContainsKey($key) -or $original.Members[$key].Raw -cne $merged.Members[$key].Raw) { throw 'Unrelated manifest property changed during round trip.' }
    }
    foreach ($path in $Paths) { if (-not (Assert-StackManifest $merged).Contains((Get-StackManifestKey $path))) { throw 'Merged manifest is missing a requested path.' } }
    return [pscustomobject]@{ Text = $mergedText; Changed = $true }
}
