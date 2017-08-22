'----------------------------------------------------------
' Plugin for OCS Inventory NG 2.x
' Script :		Retrieve uptime PC since last reboot
' Version :		2.00
' Date :		24/07/2017
' Author :		Stéphane PAUTREL (acb78.com)
'----------------------------------------------------------
' OS checked [X] on	32b	64b	(Professionnal edition)
'	Windows XP	[X]	[ ]
'	Windows Vista	[X]	[X]
'	Windows 7	[X]	[X]
'	Windows 8.1	[X]	[X]	
'	Windows 10	[X]	[X]
' ---------------------------------------------------------
' NOTE : No checked on Windows 8
' ---------------------------------------------------------
On Error Resume Next

Set colOS = GetObject("winmgmts:").InstancesOf("Win32_OperatingSystem")

For Each objOS in colOS
	sLastBoot = ConvWbemTime(objOS.LastBootUpTime)
	sNow = ConvWbemTime(objOS.LocalDateTime)
	uptimeTmps = DateDiff("s",CDate(sLastBoot),CDate(sNow))
	Wscript.echo _
		"<UPTIME>" & VbCrLf &_
		"<TIME>" & uptime(uptimeTmps) & "</TIME>" & VbCrLf &_
		"</UPTIME>"
Next

Function ConvWbemTime(IntervalFormat)
	Dim sYear, sMonth, sDay, sHour, sMinutes, sSeconds
	sYear = mid(IntervalFormat, 1, 4)
	sMonth = mid(IntervalFormat, 5, 2)
	sDay = mid(IntervalFormat, 7, 2)
	sHour = mid(IntervalFormat, 9, 2)
	sMinutes = mid(IntervalFormat, 11, 2)
	sSeconds = mid(IntervalFormat, 13, 2)

  ' Returning format yyyy-mm-dd hh:mm:ss
	ConvWbemTime = sYear & "-" & sMonth & "-" & sDay & " " _
				 & sHour & ":" & sMinutes & ":" & sSeconds
End Function

Function UpTime(S)
	M=S\60 : S=S mod 60 : H=M\60 : M=M mod 60 : D=H\24
	UpTime=D &" jours, " & H MOD 24 & " heures, " & M & " minutes"
End Function
