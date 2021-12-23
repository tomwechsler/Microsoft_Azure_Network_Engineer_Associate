# Stop an existing firewall

$azfw = Get-AzFirewall -Name "FW Name" -ResourceGroupName "RG Name"
$azfw.Deallocate()
Set-AzFirewall -AzureFirewall $azfw

# Start the firewall

$azfw = Get-AzFirewall -Name "FW Name" -ResourceGroupName "RG Name"
$vnet = Get-AzVirtualNetwork -ResourceGroupName "RG Name" -Name "VNet Name"
$publicip1 = Get-AzPublicIpAddress -Name "Public IP1 Name" -ResourceGroupName "RG Name"
$publicip2 = Get-AzPublicIpAddress -Name "Public IP2 Name" -ResourceGroupName "RG Name"
$azfw.Allocate($vnet,@($publicip1,$publicip2))

Set-AzFirewall -AzureFirewall $azfw

#For a firewall configured for forced tunneling, stopping is the same. But starting requires the management public IP to be re-associated back to the firewall:

# Stop an existing firewall

$azfw = Get-AzFirewall -Name "FW Name" -ResourceGroupName "RG Name"
$azfw.Deallocate()
Set-AzFirewall -AzureFirewall $azfw

# Start the firewall

$azfw = Get-AzFirewall -Name "FW Name" -ResourceGroupName "RG Name"
$vnet = Get-AzVirtualNetwork -ResourceGroupName "RG Name" -Name "VNet Name"
$pip= Get-AzPublicIpAddress -ResourceGroupName "RG Name" -Name "azfwpublicip"
$mgmtPip2 = Get-AzPublicIpAddress -ResourceGroupName "RG Name" -Name "mgmtpip"
$azfw.Allocate($vnet, $pip, $mgmtPip2)
$azfw | Set-AzFirewall
