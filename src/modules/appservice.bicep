// =============== appservice.bicep =============

targetScope = 'resourceGroup'

@description('Web App name')
param appServiceName string 

@description('App Service Plan name')
param appServicePlanName string 

@description('Location')
param location string 

@description('SKU for App Service Plan')
param sku string 

@description('HTTPS inly')
param httpsOnly bool

@description('Owner tag')
param owner string 

@description('Enviroment tag')
param environment string 

@description('Cost center tag')
param costCenter string 

// App Service Plan 
resource appServicePlan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: appServiceName
  location: location
  sku: {
    name: sku
    tier: sku == 'B1' ? 'Basic' : 'Standard'
    size: sku
    capacity: 1
  }
  tags: {
    owner: owner 
    environment: environment
    costCenter: costCenter
  }
}

// Web App
resource webApp 'Microsoft.Web/sites@2024-11-01' = {
  name: appServiceName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: httpsOnly
  }
  tags: {
    owner: owner 
    environment: environment
    costCenter: costCenter
  }
}

// Output 
output appServicePlanId string = appServicePlan.id
output webAppUrl string = 'https://${webApp.name}.azzurewebsites.net'
