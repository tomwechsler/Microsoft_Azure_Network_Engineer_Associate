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

# Create Virtual Networks and subnets

az network vnet create --name hub-vnet --resource-group $rg --location $location --address-prefixes 10.0.0.0/16 --subnet-name hub-subnet-a --subnet-prefix 10.0.1.0/24

az network vnet create --name spoke1-vnet --resource-group $rg --location $location --address-prefixes 10.1.0.0/16 --subnet-name spoke-1-subnet-a --subnet-prefix 10.1.1.0/24

# Create Gateway subnets

az network vnet subnet create -g $rg --vnet-name hub-vnet -n GatewaySubnet --address-prefix 10.0.0.0/27

az network vnet subnet create -g $rg --vnet-name spoke1-vnet -n GatewaySubnet --address-prefix 10.1.0.0/27

# Create two Linux machines. One in each network

az vm create --resource-group $rg --name spoke-1-vm --image Ubuntu2204 --generate-ssh-keys --public-ip-address myPublicIP-spoke-1-vm --public-ip-sku Standard --vnet-name spoke1-vnet --subnet spoke-1-subnet-a --size Standard_B1s

az vm create --resource-group $rg --name hub-vm --image Ubuntu2204 --generate-ssh-keys --public-ip-address myPublicIP-nva --public-ip-sku Standard --vnet-name hub-vnet --subnet hub-subnet-a --size Standard_B1s

# Add rules to default NIC NSGs to allow ICMP
az network nsg rule create --resource-group $rg --nsg-name hub-vmNSG --name allowIcmp --priority 110 --destination-port-ranges 0-65535 --access Allow --protocol Icmp

az network nsg rule create --resource-group $rg --nsg-name spoke-1-vmNSG --name allowIcmp --priority 110 --destination-port-ranges 0-65535 --access Allow --protocol Icmp