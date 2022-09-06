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

