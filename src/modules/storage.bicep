// =============== storage.bicep =============

targetScope = 'resourceGroup'

@description('Storage account name')
param storageName string 

@description('Location')
param location string

@description('Owner tag')
param owner string 

@description('Enviroment tag')
param enviroment string

@description('Cost center tag')
param costCenter string 

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {}
  tags: {
    owner: owner
    environment: enviroment
    costCenter: costCenter
  }
}

