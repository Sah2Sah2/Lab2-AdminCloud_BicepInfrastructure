targetScope = 'resourceGroup' // Under my personal RG

metadata description = 'Main Bicep file for deploying Azure infrastructure'

// ------------------------------PARAMETERS--------------------------------------------

// Resource group 
@description('Name of the RG')
param rgName string

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


// --------------------To do: Resources/Modules------------------------------------

// To do: call the modules

// Storage 
module StorageAgcount './modules/storage.bicep' = {
  name: 'storage-${environment}'
  params: {
    storageName: storageAccountName
    location: location
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


//--------------------OUTPUTS-----------------
output webAppUrl string = 'https://${webAppName}.azurewebsites.net'
