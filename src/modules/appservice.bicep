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

@description('SKU capacity for the App Service Plan')
param skuCapacity int

@description('HTTPS Only')
param httpsOnly bool

@description('Owner tag')
param owner string 

@description('Enviroment tag')
param environment string 

@description('Cost center tag')
param costCenter string 

@description('Key Vault secret URI')
param keyVaultSecretUri string 

// App Service Plan 
resource appServicePlan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: sku
    tier: sku == 'B1' ? 'Basic' : 'Standard'
    size: sku
    capacity: skuCapacity
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
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: httpsOnly
    siteConfig: {
      appSettings: [
        {
          name: 'MY_SECRET'
          value: '@Microsoft.KeyVault(SecretUri=${keyVaultSecretUri})'
          //keyVaultSecretUri
        }
      ]
    }
  }
  tags: {
    owner: owner 
    environment: environment
    costCenter: costCenter
  }
}

//--------------------OUTPUTS-----------------

output appServicePlanId string = appServicePlan.id
output webAppName string = webApp.name
output webAppUrl string = 'https://${webApp.name}.azurewebsites.net'
output webAppPrincipalId string = webApp.identity.principalId
