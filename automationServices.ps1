try{
   .\login.ps1
} catch {
    Write-Host "login script is missing"
    Login-AzureRMAccount
}
#Import your modules here
Import-Module AzureRM.Resources
Import-Module AzureRM.Network

<#  Task description
Perform these preliminary steps that allow you to proceed with Automation account creation:
1.done.	Log in to portal.azure.com with your test (non-production) Microsoft account. (Subscribing for Azure trial is a course prerequisite).
2.done.	Create a resource group “MyAutomationHelper” in region “West Central US” (you can choose any region that allows you to maintain Automation account in your subscription.) 
3.done.	Create a resource group “MyVMs” in region “West Central US” (you can choose any region that you prefer to maintain virtual machines in your subscription.)
4.done.	Locate azure virtual networks tab in Azure preview portal and create a virtual network. Set the name of virtual network to 
“MyVnet”.  Target it to resource group “MyVMs” and region “West Central US” (or your preferred region based on item 3.) 
Assign a private address space to Vnet, for example, 172.16.0.0/16. Create one or more subnets in your Vnet and assign it an address range out of VNet space, for example,
 172.16.1.0/24, 172.16.2.0/24, and so on. Name subnets “MySubnet1”, “MySubnet2” etc.

#>
#Input values
$location="West Central US"
$RGVnetName="MyVMs"
$RGAutomationName="MyAutomationHelper"
$RGVnet
$RGAutomation
$Subnet1Name="MySubnet1"
$Subnet1Address="172.16.1.0/24"
$Subnet2Name="MySubnet2"
$Subnet2Address="172.16.2.0/24"
$VnetName="MyVnet"
$VnetAddress="172.16.0.0/16"
$Vnet
$PrincipalAutomationAcountName=""
$PrincipalAutomationAcountName=""
#Functions to perform specific steps
#Create/delete resource groups
function createRGs{
  Write-Host "crete RGS"
  $RGVnet=New-AzureRmResourceGroup -Name $RGVnetName -Location $location
  $RGAutomation=New-AzureRmResourceGroup -Name $RGAutomationName -Location $location
}
function deleteRGs{
    Write-Host "delete RGS"
    Remove-AzureRmResourceGroup -Name $RGVnetName -force
    Remove-AzureRmResourceGroup -Name $RGAutomationName -Force
}
#Create/delete Networks
function createNetworks{
    Write-Host "crete Networks"
    $subnets=@()
    $subnets+= New-AzureRmVirtualNetworkSubnetConfig -Name $Subnet1Name -AddressPrefix $Subnet1Address
    $subnets+= New-AzureRmVirtualNetworkSubnetConfig -Name $Subnet2Name -AddressPrefix $Subnet2Address
    $Vnet= New-AzureRMVirtualNetwork -Name $VnetName -ResourceGroupName $RGVnetName -location $location -addressprefix $VnetAddress -subnet $subnets
}
function deleteNetworks{
    Write-Host "crete Networks"
    Remove-AzureRMVirtualNetwork -Name $VnetName
}
#Create/delete Automation Accounts
function createAutomationPrincipal{

}
function deleteAutomationPrincipal{

}
function createAutomationAccount{

}
function deleteAutomationAccount{

}
#Container functions. Just invoke your functions here
function createAll  {
#write here steps to perform home task    
  createRGs
  createNetworks
  createAutomationPrincipal
  createAutomationAccount

}
function deleteAll {
#write here steps to clean after home task
  deleteRGs
  deleteNetworks
  deleteAutomationPrincipal
  deleteAutomationAccount
}
createNetworks
#createAll
#sleep 3600
#make screenshots to prove Home task 
#deleteAll