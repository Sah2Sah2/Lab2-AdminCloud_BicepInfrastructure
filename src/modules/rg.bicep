// =============== rg.bicep =============
// OBS: do not call in Main 

targetScope = 'subscription' // Subscription scoped deployment 

@description('Resource Group name')
param rgName string 

@description('Location for the rg')
param location string 

@description('Owner tag')
param owner string 

@description('Environment tag')
param enviroment string 

@description('Cost center tag')
param costCenter string 
