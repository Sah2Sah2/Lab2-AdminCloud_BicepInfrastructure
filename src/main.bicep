targetScope = 'resourceGroup' // Under my personal RG

metadata description = 'Main Bicep file for deploying Azure infrastructure'

// ------------------------------PARAMETERS--------------------------------------------

/*// Resource group 
@description('Name of the RG')
param rgName string*/

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

// Tier 
@description('App Service Plan SKU')
@allowed(['B1', 'S1'])
param appServicePlanSku string = 'B1'

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

// Environments 
@description('Deployment environment')
@allowed(['dev','test','prod'])
param environment string = 'dev'

// Owner
@description('Owner')
param owner string 

// Billing
@description('Cost center tag')
param costCenter string 

// Https only
param httpsOnly bool

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
var storageAccountName = '${storagePrefix}-sa-${environment}-${uniqueString(resourceGroup().id)}'

// Web App
var webAppName = '${namePrefix}-web-${environment}-${uniqueString(resourceGroup().id)}'

// Autoscale 
var autoscaleName = '${namePrefix}-autoscale-${environment}'


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

// App Service 
module AppService './modules/appservice.bicep' = {
  name: 'app-${environment}'
  params: {
    appServiceName: webAppName
    appServicePlanName: appServicePlanResourceName 
    location: location 
    sku: appServicePlanSku
    httpsOnly: httpsOnly
    owner: owner
    environment: environment
    costCenter: costCenter
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

// To do: add Key Vault module + a param in web app module 


//--------------------OUTPUTS-----------------

output webAppUrl string = AppService.outputs.webAppUrl
output appServicePlanId string = AppService.outputs.appServicePlanId

output storageAccountId string = StorageAccount.outputs.storageAccountId

