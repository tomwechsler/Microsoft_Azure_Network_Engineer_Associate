###############################
####### SCRIPT DETAILS ########
# Intended Purpose: Setup Azure environment
# Disclaimer: This script is intended to be used only for learning purposes.
# Message: To use this script for your own Azure environments
#       1.) Create your own resource group variable.
#       2.) Comment out variable in variables section.
#       3.) Uncomment below commands and assign your own resource group and location.
# rg=your-resource-group-here
# location=your-location-here
###############################

##############################
##### START - VARIABLES ######
##############################

# Get resource group and set to variable $rg
$rg = az group list --query '[].name' -o tsv

# Assign location variable to playground resource group location
$location = az group list --query '[].location' -o tsv

##############################
##### END - VARIABLES ######
##############################

##############################
####### START - SCRIPT #######
##############################

# Create storage account name, use a unique name

storagename=cttaz700sta

# Create storage account

az storage account create --name $storagename --resource-group $rg --location $location

# Create Consumer Virtual Network and subnets

az network vnet create --name consumer-vnet --resource-group $rg --location $location --address-prefixes 10.0.0.0/16 --subnet-name consumer-subnet --subnet-prefix 10.0.1.0/24



# Create provider network + load balancer

az network vnet create --resource-group $rg --location $location --name provider-vnet --address-prefixes 10.1.0.0/16 --subnet-name provider-subnet --subnet-prefixes 10.1.0.0/24

az network lb create --resource-group $rg --name provider-Loadbalancer --sku Standard --vnet-name provider-vnet --subnet provider-subnet --frontend-ip-name myFrontEnd --backend-pool-name myBackEndPool

az network lb probe create --resource-group $rg --lb-name provider-Loadbalancer --name myHealthProbe --protocol tcp --port 80

az network lb rule create --resource-group $rg --lb-name provider-Loadbalancer --name myHTTPRule --protocol tcp --frontend-port 80 --backend-port 80 --frontend-ip-name myFrontEnd --backend-pool-name myBackEndPool --probe-name myHealthProbe --idle-timeout 15 --enable-tcp-reset true