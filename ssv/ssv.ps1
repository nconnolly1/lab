Import-Certificate -FilePath c:\vagrant\SANsymphony\DataCore-1.cer -CertStoreLocation 'Cert:\LocalMachine\TrustedPublisher'
Import-Certificate -FilePath c:\vagrant\SANsymphony\DataCore-1.cer -CertStoreLocation 'Cert:\LocalMachine\TrustedPublisher'

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted
Start-Process "C:\vagrant\SANsymphony\DataCoreServer.exe" -ArgumentList "\scripted" -Wait
