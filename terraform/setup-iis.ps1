# Ensure IIS is installed
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole -All;

# Ensure the folder exists
$siteName = 'DuplicateSite'
$sitePath = 'C:\inetpub\wwwroot\DuplicateSite'
$bindingIP = '*'
$bindingPort = 8090

Write-Output "Ensuring folder exists at: $sitePath"
if (-not (Test-Path $sitePath)) {
    New-Item -Path $sitePath -ItemType Directory
    Write-Output "Created directory: $sitePath"
} else {
    Write-Output "Directory already exists: $sitePath"
}

Write-Output "Checking if site exists: $siteName"
$site = Get-Website | Where-Object { $_.Name -eq $siteName }

if ($null -eq $site) {
    Write-Output "Site does not exist. Creating site: $siteName"
    New-Website -Name $siteName -PhysicalPath $sitePath -Port $bindingPort
} else {
    Write-Output "Site exists. Updating site: $siteName"
    Set-ItemProperty "IIS:\Sites\$siteName" -Name physicalPath -Value $sitePath
    Remove-WebBinding -Name $siteName -IPAddress $bindingIP -Port $bindingPort
    New-WebBinding -Name $siteName -IPAddress $bindingIP -Port $bindingPort
    Start-Website -Name $siteName
}

Write-Output "Completed IIS setup for: $siteName"
