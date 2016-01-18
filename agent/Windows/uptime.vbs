'' Plugin for OCS Inventory NG 2.x
'' Uptime 1.0.1 (04/05/2014)
'' PRIOU Guillaume

Set objWMIService=GetObject("winmgmts:\\.\root\cimv2")
Set colOperatingSystems=objWMIService.ExecQuery _
  ("Select * From Win32_PerfFormattedData_PerfOS_System")
For Each objOS in colOperatingSystems
  intSystemUptime=Int(objOS.SystemUpTime)
  TimedAt=FormatDateTime(Date(),2) &", " &FormatDateTime(Time(),4)
  Wscript.echo "<UPTIME>"
  Wscript.echo UpTime(intSystemUptime)
  Wscript.echo "</UPTIME>"
next
Function UpTime(S)
  M=S\60 : S=S mod 60 : H=M\60 : M=M mod 60 : D=H\24
  UpTime="<TIME>" & D &" Days, " & H MOD 24 & " Hours, " & M & " Minutes </TIME>"
End Function
