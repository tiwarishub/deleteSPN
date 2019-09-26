$graphToken = "Bearer <Token>"

if ([string]::IsNullOrEmpty($(Get-AzureRmContext).Account)) {Login-AzureRmAccount}

$Prefix = Read-Host -Prompt 'Input service principal prefix you want to delete'

if ($Prefix) {
    $applications = Get-AzureRmADApplication -DisplayNameStartWith $Prefix
} else {
    Write-Host "No prefix provided, exiting."
    exit;
}
if (!$applications) {
    Write-Host "No application found having prefix '$Prefix'"
    exit;
}
$appName = ($applications.DisplayName | ForEach-Object { "{0}`n" -f $_});
$confirm = Read-Host -Prompt "Following applications will be deleted. `n $appName `nPress 'Y' to confirm.";
if ($confirm -eq 'Y') {
    $applications.ObjectId | ForEach-Object { Remove-AzureRmADApplication -Force -ObjectId $_; }
    Start-Sleep -s 120
    $applications.ObjectId | ForEach-Object {
        $uri = "https://graph.microsoft.com/beta/directory/deletedItems/$_"
        Invoke-RestMethod -Method DELETE -Headers @{"Authorization"=$graphToken; "Accept"="application/json, text/plain, */*"} -Uri $uri
    }
}
