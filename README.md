# Azure infrastucture deployment with Bicep 

![Bicep](https://img.shields.io/badge/Bicep-azure-blue)
![Azure CLI](https://img.shields.io/badge/Azure%20CLI-azure-blue)

## Project description 

This project.... 

## Table of contents

## Prerequisites 
- Azure subscription
- Azure CLI installed
- Bicep CLI installed 
- Permissions to create resource groups and deploy resources

## Repository structure 

```text
/modules                           # Contains reusable Bicep modules
│
├── appservice.bicep               # App Service 
├── autoscale.bicep                # Autoscale
├── keyvault.bicep                 # Key Vault
├── rg.bicep                       # RG 
└── storage.bicep                  # Storace account 
 main.bicep                        # Orchestrates all modules and deploys resources

/parameters                         # Contains environment-specific parameter files
│
├── dev.json                       # Parameters for development
├── prod.json                      # Parameters for production
└── test.json                      # Parameters for testing

/.gitignore                       # Git ignore rules               

/README.md                        # Readme file
```

## Deployment instructions 

Deploy each environment separately (dev, test, prod) on your personal Resouece Group 

Dev
Test
Prod


## Notes 
- secretValueFromCli
- All resources are tagged with owner, environemnt, costCenter
- Autoscale is enable only in production

## Outputs 
After deployment, the following are available 
-
-
-
-

Command to show the outputs: 
```bash
```

## Screenshots