// =============== rg.bicep =============
// OBS: do not call in Main 

targetScope = 'subscription' // Subscription scoped deployment 

@description('Resource Group name')
param rgName string 

@description('Location for the rg')
param location string 

@description('Owner tag')
param owner string 

@description('Environment tag')
param environment string 

@description('Cost center tag')
param costCenter string 


resource rg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: rgName
  location: location 
  tags: {
    owner: owner 
    environment: environment
    costCenter: costCenter
  }
}

//--------------------OUTPUTS-----------------

output rgId string = rg.id
