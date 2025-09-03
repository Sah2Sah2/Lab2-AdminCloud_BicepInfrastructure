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

// Web App

// Output 
