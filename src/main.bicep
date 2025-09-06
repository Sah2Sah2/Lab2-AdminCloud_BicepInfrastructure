targetScope = 'resourceGroup' // Under my personal RG

metadata description = 'Main Bicep file for deploying Azure infrastructure'

// ------------------------------PARAMETERS--------------------------------------------

/*// Resource group 
@description('Name of the RG')
param rgName string*/

// Environments 
@description('Deployment environment')
@allowed(['dev','test','prod'])
param environment string = 'dev'

// Tier 
@description('App Service Plan SKU')
@allowed(['B1', 'S1'])
param appServicePlanSku string = 'B1'

// SKU (prod scale higher)
@description('App Service Plan instance capacity')
param skuCapacity int = environment == 'prod' ? 2 : 1 

// Location for the RG
@description('Azure region for all the resources')
param location string 

// Storage Account
@minLength(3)
@maxLength(11)
@description('Prefix for globally unique storage account names')
param storagePrefix string 

// Prefix 
@description('Prefix for naming resources')
param namePrefix string 

// Storage SKU
@description('Storage Account SKU')
@allowed([
  'Standard_LRS'
])
param skuName string = 'Standard_LRS'

// Storage kind
@description('Storage Account kind')
@allowed([
  'StorageV2'
])
param storageKind string = 'StorageV2'

// Owner
@description('Owner')
param owner string 

// Billing
@description('Cost center tag')
param costCenter string 

// Https only
param httpsOnly bool

// Key Vault (VG)
@secure()
@description('Secret value for Key Vault')
param secretValueFromCLI string 

@description('Name of the secret in Key Vault')
param secretName string = 'MySecret'

// -------AUTOSCALE PARAMETERS---------

@description('Minimum instance count for autoscale')
param minInstanceCount int = environment == 'prod' ? 2 : 1 

@description('Maximum instance count for autoscale')
param maxInstanceCount int = environment == 'prod' ? 5 : 2 

@description('Default initial instance count')
param defaultInstanceCount int = environment == 'prod'? 2 : 1 

//---------NAMING VARIABLES--------------

// App Service Plan 
var appServicePlanResourceName = '${namePrefix}-app-${environment}-${uniqueString(resourceGroup().id)}'

// Storage account 
var storageAccountName = toLower('${storagePrefix}${environment}${substring(uniqueString(resourceGroup().id), 0, 8)}')

// Web App
var webAppName = '${namePrefix}-web-${environment}-${uniqueString(resourceGroup().id)}'

// Autoscale 
var autoscaleName = '${namePrefix}-autoscale-${environment}'

// Key vault 
var keyVaultName = '${namePrefix}-kv-${environment}'

// Key Vault secret name 
var keyVaultSecretName = '${secretName}-${uniqueString(resourceGroup().id)}'


// --------------------Resources/Modules------------------------------------

// Storage 
module StorageAccount './modules/storage.bicep' = {
  name: 'storage-${environment}'
  params: {
    storageName: storageAccountName
    location: location
    skuName: skuName 
    kind: storageKind
    owner: owner
    environment: environment
    costCenter: costCenter
  }
}

// Key vault (VG)
module KeyVault './modules/keyvault.bicep' = {
  name: 'kv-${environment}'
  params: {
    keyVaultName: keyVaultName
    location: location
    owner: owner 
    environment: environment
    costCenter: costCenter
    secretName: keyVaultSecretName
    secretValue: secretValueFromCLI
  }
}

// App Service 
module AppService './modules/appservice.bicep' = {
  name: 'app-${environment}'
  params: {
    appServiceName: webAppName
    appServicePlanName: appServicePlanResourceName 
    location: location 
    sku: appServicePlanSku
    skuCapacity: skuCapacity
    httpsOnly: httpsOnly
    owner: owner
    environment: environment
    costCenter: costCenter
    keyVaultSecretUri: KeyVault.outputs.secretUri
  }
}

// Autoscale (VG)
// Autoscale -> only for PROD, do not output its ID for dev/test to avoid null errors
module Autoscale './modules/autoscale.bicep' = if (environment == 'prod') {
  name: 'autoscale-${environment}'
  params: {
    autoscaleName: autoscaleName
    minInstanceCount: minInstanceCount
    maxInstanceCount: maxInstanceCount
    defaultInstanceCount: defaultInstanceCount
    targetResourceId: AppService.outputs.appServicePlanId
    owner: owner 
    environment: environment
    costCenter: costCenter
  }
}

//--------------------Role assignment for KV (VG)-----------------

resource assignKvRole 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'assignKvRoleScript'
  location: location
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: '11'
    timeout: 'PT30M'
    retentionInterval: 'P1D'
    scriptContent: '''
    $kvId = '${KeyVault.outputs.keyVaultResourceId}'
    $principalId = '${AppService.outputs.webAppPrincipalId}'
    New-AzRoleAssignment -ObjectId $principalId -RoleDefinitionName 'Key Vault Adminisrator' -Scope $kvId
    '''

    forceUpdateTag: uniqueString(resourceGroup().id)
  }
  dependsOn: [
    AppService
    KeyVault
  ]
}

//--------------------OUTPUTS-----------------

output webAppUrl string = AppService.outputs.webAppUrl
output appServicePlanId string = AppService.outputs.appServicePlanId

output storageAccountId string = StorageAccount.outputs.storageAccountId

output keyVaultSecretUri string = KeyVault.outputs.secretUri

