$FirewallStatus = Get-NetFirewallProfile | Select-Object -ExpandProperty Enabled
$FirewallStatus= $FirewallStatus-contains $false
echo $(!$FirewallStatus)
