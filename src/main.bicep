targetScope = 'subscription' // Subscription to create the RG 

metadata description = 'Main Bicep file for deploying Azure infrastructure'

// Resource group 
@description('Name of the RG')
param rgName

// Location for the RG
@description('Azure region for all the resources')
param location string 

// Storage Account
@minLength(3)
@maxLength(11)
@description('Prefix for gloabblly unique storage account names')
param storagePrefix string 

// Prefix 
@description('Prefix for naming resources')
param namePrefix string 

// Tier 
@description('App Service Plan SKU')
@allowed(['B1', 'S1'])
param appServicePlanSku string = 'B1'

// Environments 
@description('Deployment enviroment')
@allowed(['dev','test','prod'])
param environment string = 'dev'

// Owner
@description('Owner')
param owner string 

// Billing
@description('Cost center tag')
param costCenter string 

// To do: create RG

// To do: call the modules

  // Storage 

  // App Service 

  // Autoscale (VG)
