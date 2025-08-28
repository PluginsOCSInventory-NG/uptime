# Get the operating system information using the modern Get-CimInstance cmdlet.
$os = Get-CimInstance -ClassName Win32_OperatingSystem

# Get the last boot time
$lastBootTime = $os.LastBootUpTime

# Calculate the uptime by subtracting the boot time from now. The result is a TimeSpan object.
$uptimeSpan = [DateTime]::Now - $lastBootTime

# Format the TimeSpan object into the desired string.
$durationString = "$($uptimeSpan.Days) days, $($uptimeSpan.Hours) hours, $($uptimeSpan.Minutes) minutes"

# Format the boot time into the 'yyyy-MM-dd HH:mm:ss' string required by OCS.
$logDateString = Get-Date $lastBootTime -Format 'yyyy-MM-dd HH:mm:ss'

# Build the final XML string.
@"
<UPTIME>
<LOG_DATE>$logDateString</LOG_DATE>
<DURATION>$durationString</DURATION>
</UPTIME>
"@