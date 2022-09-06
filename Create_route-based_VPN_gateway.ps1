Set-Location C:\
Clear-Host

#Install the Az module
Install-Module -Name Az -AllowClobber -Force -Verbose

#Connect to Azure
Connect-AzAccount

#Choose the subscription
Get-AzSubscription

Get-AzSubscription -SubscriptionName "Microsoft Azure Sponsorship" | Select-AzSubscription

Get-AzContext

#Create a resource group
New-AzResourceGroup -Name TestRG1 -Location WestEurope

#Create a virtual network
$virtualNetwork = New-AzVirtualNetwork `
  -ResourceGroupName TestRG1 `
  -Location WestEurope `
  -Name VNet1 `
  -AddressPrefix 10.1.0.0/16

$subnetConfig = Add-AzVirtualNetworkSubnetConfig `
  -Name Frontend `
  -AddressPrefix 10.1.0.0/24 `
  -VirtualNetwork $virtualNetwork

$virtualNetwork | Set-AzVirtualNetwork

#Add a gateway subnet
$vnet = Get-AzVirtualNetwork -ResourceGroupName TestRG1 -Name VNet1

Add-AzVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -AddressPrefix 10.1.255.0/27 -VirtualNetwork $vnet

$vnet | Set-AzVirtualNetwork

#Request a public IP address
$gwpip= New-AzPublicIpAddress -Name VNet1GWIP -ResourceGroupName TestRG1 -Location 'West Europe' -AllocationMethod Dynamic

#Create the gateway IP address configuration
$vnet = Get-AzVirtualNetwork -Name VNet1 -ResourceGroupName TestRG1
$subnet = Get-AzVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -VirtualNetwork $vnet
$gwipconfig = New-AzVirtualNetworkGatewayIpConfig -Name gwipconfig1 -SubnetId $subnet.Id -PublicIpAddressId $gwpip.Id

#Create the VPN gateway
New-AzVirtualNetworkGateway -Name VNet1GW -ResourceGroupName TestRG1 `
-Location 'West Europe' -IpConfigurations $gwipconfig -GatewayType Vpn `
-VpnType RouteBased -GatewaySku VpnGw1

#View the VPN gateway
Get-AzVirtualNetworkGateway -Name Vnet1GW -ResourceGroup TestRG1

#View the public IP address
Get-AzPublicIpAddress -Name VNet1GWIP -ResourceGroupName TestRG1