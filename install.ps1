# Create Internal NAT switch for VMs for 192.168.50.0/24
# Based on https://petri.com/using-nat-virtual-switch-hyper-v
if ($null -eq (Get-VMSwitch -SwitchName "NATSwitch")) {
	New-VMSwitch -SwitchName "NATSwitch" -SwitchType Internal
	New-NetIPAddress -IPAddress 192.168.50.1 -PrefixLength 24 -InterfaceAlias "vEthernet (NATSwitch)"
	New-NetNAT -Name "NATNetwork" -InternalIPInterfaceAddressPrefix 192.168.50.0/24
}

# Enable WSL support
if ("Enabled" -ne (Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux)) {
	Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
}
