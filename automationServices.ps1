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

5.	In Azure preview portal, Locate Automation accounts tab and create an automation account. Set the name of automation account to 
“MyAutomationHelper”. Target it to resource group “MyAutomationHelper” and region “West Central US” 
(or your preferred region based on item 2.) Confirm creation of RunAs account and read related precaution carefully. 
6.	Locate RunAs  accounts tab in Automation account “MyAutomationHelper”. Expand its properties, explain “Application ID” field, “Certificate thumbprint” field,
 “tenant ID field”. What IAM role is granted to this service principal in your Azure subscription? 
7.	Locate Runbooks tab in Automation account “MyAutomationHelper”. Create (or import) a runbook “MyAutomation2” of type powershell based on file MyAutomation2.ps1 in attached archive. Edit the runbook. Find and explain a code that allows you to connect to target Azure environment. Adjust AutomationConnection name, adjust target subscription id/name. Explore and use Asset hierarchy to the left of runbook edit pane. Find and explain a code that allows you to add input parameters to runbook. Save and test the runbook. Explain parameters that are prompted in test pane. Type your unique value for VM prefix,  2 for VM Count, “MyVnet” for Vnet name, “MySubnet1” for subnet name. Start the runbook, observe the result and trouble shoot if necessary. Did you face with any run time exceptions? Note: you will need to delete all resources created with appointed prefix in resource group “MyVMs” if you want to run this runbook with the same parameters. 
8.	Locate Modules tab in in Automation account “MyAutomationHelper”. Click Browse a gallery, import module AzureRM.Network into your automation account, wait until import is finished and observe the result. Notice added module. Repeat test run of runbook “MyAutomation2”. Did you face with any run time exceptions?
9.	Locate Modules tab in in Automation account “MyAutomationHelper”. Click Update Azure modules, wait until update job is finished and observe the result. Notice changed versions for each module. Repeat test run of runbook “MyAutomation2”. Did you face with any run time exceptions?
10.	Locate Runbooks tab in Automation account “MyAutomationHelper”. Create (or import) a runbook “MyAutomation1” of type powershell workflow based on file MyAutomation1.ps1 in attached archive. Edit the runbook. Adjust AutomationConnection name, adjust target subscription id/name. Use Asset hierarchy to the left of runbook edit pane. Find and explain a code that allows you to start or stop VMs simultaneously. Save and test the runbook. Explain parameters that are prompted in test pane. Type your unique value (same as in item 7) for VM prefix, “MyVMs” for resource group name, “stop” for ToDo. Start the runbook, observe the result and trouble shoot if necessary. Ensure the VMs are in stopped state. Rerun the runbook and type “start” for ToDo, ensure the VMs are in running state. 
11.	Locate Runbooks tab in Automation account “MyAutomationHelper”. Create (or import) a runbook “MyAutomation3” of type powershell workflow based on file MyAutomation3.ps1 in attached archive. Edit the runbook. Adjust AutomationConnection name, adjust target subscription id/name. Find and explain a line that allows you to pass a JSON to the runbook. Locate Variables tab in Automation account “MyAutomationHelper” and create a variable that contains JSON settings for Azure Antimalware extension. Adjust variable name in the code. Find and explain a line that allows you to pass a hash table to the runbook. Type your unique value (same as in item 7) for VM prefix, “MyVMs” for resource group name. Save and test the runbook, explain if you can run it. 
12.	Locate Modules tab in in Automation account “MyAutomationHelper”. Import powershell module ConvertFromJson based on ConvertFromJson.zip file in attached archive, wait until import is finished and observe the result. Repeat test run of runbook “MyAutomation3”, type your unique value (same as in item 7) for VM prefix,  “MyVMs” for resource group name, trouble shoot if necessary. Did you face with any run time exceptions?
13.	Create Operations management Suite workspace “MyAutomationHelper”. Get to link  https://www.microsoft.com/en-us/cloud-platform/operations-management-suite and sign in with your test (non-production) Microsoft account that you used in previous steps. Follow self-explanatory GUI and instructions (where applicable) to create new free OMS workspace and link it to your trial subscription. Set “MyAutomationHelper” for workspace name, and target it to region “West Central US” (or your preferred region based on item 2.) Enter rest of mandatory fields required for workspace registration on your own. 
14.	In OMS workspace window, click Home icon, click Settings pane, click Connected sources, click Windows servers. Find workspace ID and Key on pane to the left. Locate Variables tab in Automation account “MyAutomationHelper” and create a variable “workspaceID” that contains workspace ID and a variable “workspaceKey” that contains workspace primary Key.
15.	Locate Runbooks tab in Automation account “MyAutomationHelper”. Create (or import) a runbook “MyAutomation4” of type powershell workflow based on file MyAutomation4.ps1 in attached archive. Edit the runbook. Adjust AutomationConnection name, adjust target subscription id/name, adjust names for variables that contain workspaceID and workspaceKey. Test the runbook, type your unique value (see item 7)  for VM prefix,  “MyVMs” for resource group name, troubleshoot if necessary. Ensure OMS extensions are installed.
16.	In OMS workspace window, click Home icon, click Settings pane, click Connected sources, click Windows servers, click line Windows Computers Connected.  (Wait until OMS agents are got registered in Workspace.)

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