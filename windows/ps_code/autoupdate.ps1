$UpdateSettings = (New-Object -com "Microsoft.Update.AutoUpdate").Settings

$NotificationLevel = $UpdateSettings.NotificationLevel
echo $NotificationLevel
