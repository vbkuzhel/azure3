Import-Module Azure
#Import-Module AzureRm.Resource
#Import-Module AzureRm.Network
$certSubject="CN="+$env:computername;
$certLocation="cert:\CurrentUser\My"
$currentDate =Get-Date
$endDate = $currentDate.AddYears(1)
$notAfter = $endDate.AddYears(1)
$certs=Get-ChildItem -Path $certLocation| where {$PSitem.Subject -eq $certSubject }
if (!$certs) { Write-Host "no certificate. lets create certificate and service princiapl for this computer"
$cert=New-SelfSignedCertificate -DnsName $env:computername -CertStoreLocation $certLocation 
$keyValue = [System.Convert]::ToBase64String($cert.GetRawCertData())
Login-AzureRmAccount
$sp = New-AzureRMADServicePrincipal -DisplayName exampleapp -CertValue $keyValue -EndDate $cert.NotAfter -StartDate $cert.NotBefore
Sleep 20
New-AzureRmRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $sp.ApplicationId
}