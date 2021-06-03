Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart

Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
Install-Package -Name docker -ProviderName DockerMsftProvider
