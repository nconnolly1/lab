$dir = Split-Path $MyInvocation.MyCommand.Path -Parent
$dir = $dir + '\config'

$out = $dir + '\dhcp.conf'
Export-DhcpServer -File $out

$dns = $env:SystemRoot + '\System32\dns\lab.local.dns'
Copy-Item $dns $dir -Force

$reverse = $env:SystemRoot + '\System32\dns\50.168.192.in-addr.arpa.dns'
Copy-Item $reverse $dir -Force
