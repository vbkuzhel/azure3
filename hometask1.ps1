Import-Module Azure
#Import-Module Azure.Rm.Resource
#Import-Module Azure.Rm.Network
$certSubject="CN="+$env:computername;
$certLocation="cert:\CurrentUser\My"
$currentDate =Get-Date
$endDate = $currentDate.AddYears(1)
$notAfter = $endDate.AddYears(1)
$certs=Get-ChildItem -Path $certLocation| where {$PSitem.Subject -eq $certSubject }
if (!$certs) { Write-Host "no certificate. lets create certificate and service princiapl for this computer" 
}