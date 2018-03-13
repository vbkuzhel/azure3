try{
   .\login.ps1
} catch {
    Write-Host "login script is missing"
    Login-AzuereRMAccount
}
function createAll  {
#write here steps to perform home task    
}
function deleteAll {
#write here steps to clean after home task
}
createAll
sleep 3600
#make screenshots to prove Home task 
deleteAll