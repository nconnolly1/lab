$dir = Split-Path $MyInvocation.MyCommand.Path -Parent
$dir = $dir + '\config'

$out = $dir + '\conf.dhcp'
Export-DhcpServer -File $out -Force

$dns = $env:SystemRoot + '\System32\dns\lab.local.dns'
Copy-Item $dns $dir -Force

$reverse = $env:SystemRoot + '\System32\dns\50.168.192.in-addr.arpa.dns'
Copy-Item $reverse $dir -Force
