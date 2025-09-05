// ===============autoscale.bicep =============

targetScope = 'resourceGroup'

@description('Autoscale setting name')
param autuscaleName string 

@description('Minimun instance count')
param minInstanceCount int 

@description('Max instance count')
param maxInstanceCount int 

@description('Default instance count')
param defaultInstanceCount int 

@description('Target resource')
param targetResourceId string 

@description('owner tag')
param owner string 

@description('Environment tag')
param environment string 

@description('Cost center tag')
param costCenter string


