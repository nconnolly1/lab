Install-WindowsFeature -name Web-Server -IncludeManagementTools
Install-WindowsFeature -Name 'Multipath-IO'

Start-Service msiscsi
Set-Service msiscsi -startuptype "automatic"
