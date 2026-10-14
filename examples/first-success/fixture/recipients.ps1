function Get-NotificationRecipients {
    param([string[]]$Recipients)
    # Defect: equivalent recipients can receive the same notification twice.
    foreach ($recipient in $Recipients) {
        if (-not [string]::IsNullOrWhiteSpace($recipient)) { $recipient.Trim() }
    }
}
