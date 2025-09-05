// =============== keyvault.bicep =============

targetScope = 'resourceGroup'

@description('Key Vault name')
param keyVaultName string 

@description('Location')
param location string 

@description('Owner tag')
param owner string 

@description('Enviroment tag')
param environment string 

@description('Cost center tag')
param costCenter string 

@description('Secret name')
param secretName string 

@secure()
@description('Secret value')
param secretValue string 

resource kv 'Microsoft.KeyVault/vaults@2024-11-01' = {
  name: keyVaultName
  location: location
  properties: { 
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: []
    enableSoftDelete: true
  }
  tags: {
    owner: owner
    enviroment: environment
    costCenter: costCenter
  }
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2024-11-01' = {
  parent: kv
  name: secretName
  properties: { 
    value: secretValue
  }
}

//--------------------OUTPUTS-----------------

output secretUri string = secret.properties.id
