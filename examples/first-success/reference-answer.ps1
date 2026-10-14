# Human-written oracle reference, NOT an AI-generated result or skill trial.
# The setup instructions copy only fixture/, not this answer, into the workspace.
function Get-NotificationRecipients {
    param([string[]]$Recipients)
    $seen = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach ($recipient in $Recipients) {
        if (-not [string]::IsNullOrWhiteSpace($recipient)) {
            $value = $recipient.Trim()
            if ($seen.Add($value)) { $value }
        }
    }
}
