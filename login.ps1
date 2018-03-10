Import-Module Azure
import-module PKI
$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$certSubject="CN=azure"+$env:computername;
$certLocation="cert:\CurrentUser\My"
$currentDate =Get-Date
$endDate = $currentDate.AddYears(1)
$notAfter = $endDate.AddYears(1)
$principalName="az"+$env:computername
try{
    $creds=Get-Content -Raw -Path azurecreds.json | ConvertFrom-Json
    #$cert=Get-ChildItem -Path $certLocation|where Thumbprint -eq $creds.thumbprint
    Login-AzureRmAccount -ServicePrincipal -CertificateThumbprint $creds.thumbprint -ApplicationId $creds.applicationid -TenantId $creds.tenantid -Subscription $creds.subscription
} catch {
    if ($true){
    Write-Host "no json file. let us have everything done for the first time"
    $cert = New-SelfSignedCertificate -CertStoreLocation $certLocation -DnsName $certSubject 
    $keyValue = [System.Convert]::ToBase64String($cert.GetRawCertData())
    Login-AzureRmAccount 
    $sp = New-AzureRMADServicePrincipal -DisplayName $principalName -CertValue $keyValue -EndDate $cert.NotAfter -StartDate $cert.NotBefore
    Sleep 20
    New-AzureRmRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $sp.ApplicationId
    $applicationID=$sp.ApplicationId
    $tenant=(Get-AzureRmContext).Tenant.TenantId
    $subscription=(Get-AzureRmContext).Subscription.Id
    $thumbprint=$cert.Thumbprint
    @{applicationid=$applicationID;tenantid=$tenant;subscription=$subscription;thumbprint=$thumbprint} | ConvertTo-Json -Compress  | Out-File 'azurecreds.json'}
} 