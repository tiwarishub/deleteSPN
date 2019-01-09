if ([string]::IsNullOrEmpty($(Get-AzureRmContext).Account)) {Login-AzureRmAccount}

$Prefix = Read-Host -Prompt 'Input service principal prefix you want to delete'

$applications = AzureRmADServicePrincipal -SearchString $Prefix;
if (!$applications) {
    Write-Host "No application found having prefix '$Prefix'"
    exit;
}
$appName = ($applications.DisplayName | ForEach-Object { "{0}`n" -f $_});
$confirm = Read-Host -Prompt "Following applications will be deleted. `n $appName `nPress 'Y' to confirm.";
if ($confirm -eq 'Y') {
    $applications.Id | ForEach-Object { Remove-AzureRmADServicePrincipal -Force -ObjectId $_ }
}