$graphToken = "<token>"

$Prefix = Read-Host -Prompt 'Input service principal prefix you want to delete'

if ($Prefix)
{
    $uri = 'https://graph.microsoft.com/beta/directory/deleteditems/microsoft.graph.application?$filter=startswith(displayName,''' + $Prefix + "')"
    $response = Invoke-RestMethod -Method GET -Headers @{"Authorization" = "Bearer $graphToken"; "Accept" = "application/json, text/plain, */*" } -Uri $uri
    $applications = $response.value
}
else
{
    Write-Host "No prefix provided, exiting."
    exit;
}
if (!$applications)
{
    Write-Host "No application found having prefix '$Prefix'"
    exit;
}
$appName = ($applications.DisplayName | ForEach-Object { "{0}`n" -f $_ });
$confirm = Read-Host -Prompt "Following applications will be permanently deleted. `n $appName `nPress 'Y' to confirm.";
if ($confirm -eq 'Y')
{
    $applications.id | ForEach-Object {
        $uri = "https://graph.microsoft.com/beta/directory/deletedItems/$_"
        Invoke-RestMethod -Method DELETE -Headers @{"Authorization" = "Bearer $graphToken"; "Accept" = "application/json, text/plain, */*" } -Uri $uri
    }
}

