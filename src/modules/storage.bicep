// =============== storage.bicep =============

targetScope = 'resourceGroup'

@description('Storage account name')
param storageName string 

@description('Location')
param location string

@description('Storage SKU')
@allowed([
  'Standard_LRS'
])
param skuName string 

@description('Storage kind')
@allowed([
  'StorageV2'
])
param kind string 

@description('Owner tag')
param owner string 

@description('Environment tag')
param environment string

@description('Cost center tag')
param costCenter string 

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageName
  location: location
  sku: {
    name: skuName
  }
  kind: kind
  properties: {}
  tags: {
    owner: owner
    environment: environment
    costCenter: costCenter
  }
}

