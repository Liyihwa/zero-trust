$FirewallStatus = Get-NetFirewallProfile | Select-Object -ExpandProperty Enabled
$TrueCount = ($FirewallStatus | Where-Object { $_ -eq "True" }).Count
Write-Host $TrueCount
