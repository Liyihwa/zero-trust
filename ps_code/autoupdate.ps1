$AutoUpdateEnabled = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU").NoAutoUpdate -eq 0
if ($AutoUpdateEnabled){
# 这种情况下开启了自动更新
$AutoUpdateSettings = (New-Object -ComObject "Microsoft.Update.AutoUpdate").Settings
Write-Output "1 $($AutoUpdateSettings.NotificationLevel)"
}
else {
# 这种情况下没有启用自动更新
Write-Output "0 "
}