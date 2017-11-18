'--------------------------------------------------------------------------------------------------------------------
' Probe X and Y Positive and Negative Script for Mach3
' (c) James D Stallard 2017
'
'--------------------------------------------------------------------------------------------------------------------
' Notes:
' Script converts mm to inches automatically by reading your machine's native unit settings irrespective of G20/G21
' You MUST configure the following variables:
'	intProbeDiameter
'	MUST BE SET IN MM
'
'	strProbeAction
'	MUST BE ONE OF "Xpos", "Xneg", "Ypos", "Yneg"
'
' All other variables can be left at their defaults
' The script allows you to run a metric and imperial units setup on the same machine, but in different Mach3 profiles
' without having to edit intProbeDiameter each time you switch units
'--------------------------------------------------------------------------------------------------------------------
intProbeDiameter		= 3														' Set probe diameter in mm
strProbeAction			= "Xpos"												' Set probing action, valid values are "Xpos", "Xneg", "Ypos", "Yneg"

intUnits				= GetSetupUnits()										' Autoconvert script from metric to imperial
If intUnits				= 0 Then intConversionFactor = 1						' Units are mm
If intUnits				= 1 Then intConversionFactor = 25.4						' Units are in

intStartProbeDelay		= 1														' Set the amount of time in seconds you need between hitting the auto tool zero button and the probe action actually starting. Default 2

intProbeMaxTravel		= Round(50 / intConversionFactor,3)						' Maximum probe travel distance before giving up in mm if metric, inches if imperial. Default 120
intProbeFeedRate		= Round(200 / intConversionFactor,3)					' Probing action and retract feed rate in mm per minute if metric, inches per minute is imperial. Default 200

intCurrentFeed			= GetOemDRO(818)										' Get current feedrate
intStartX				= GetDro(0)												' Get X position
intStartY				= GetDro(1)												' Get Y position


If GetOemLed(825)		= 0 Then												' Check to see if the probe is already grounded

	Code "G4 P" & intStartProbeDelay											' Dwell to get your hands clear
	
Select Case strProbeAction
	Case "Xpos"	
		Code "G31 X" & intStartX + intProbeMaxTravel & " F" & intProbeFeedRate	' Execute probe action
		Code "(Probing X positive axis...)"										' Status bar message
	
		While IsMoving()														' Wait while probe action completes
		Wend
		
		Call SetDro (0, -intProbeDiameter/2)									' Set the DRO to half the probe diameter
		Sleep 200																' Wait for DRO to update
		Code "(X axis is zeroed. Tool at " & intProbeDiameter/2 & ")"			' Status bar message
		
	Case "Xneg"	
		Code "G31 X-" & intStartX + intProbeMaxTravel & " F" & intProbeFeedRate	' Execute probe action
		Code "(Probing X negative axis...)"										' Status bar message
	
		While IsMoving()														' Wait while probe action completes
		Wend
		
		Call SetDro (0, intProbeDiameter/2)										' Set the DRO to half the probe diameter
		Sleep 200																' Wait for DRO to update
		Code "(X axis is zeroed. Tool at " & intProbeDiameter/2 & ")"			' Status bar message
		
	Case "Ypos"	
		Code "G31 Y" & intStartY + intProbeMaxTravel & " F" & intProbeFeedRate	' Execute probe action
		Code "(Probing Y positive axis...)"										' Status bar message
	
		While IsMoving()														' Wait while probe action completes
		Wend
		
		Call SetDro (1, -intProbeDiameter/2)									' Set the DRO to half the probe diameter
		Sleep 200																' Wait for DRO to update
		Code "(Y axis is zeroed. Tool at " & intProbeDiameter/2 & ")"			' Status bar message
		
	Case "Yneg"	
		Code "G31 Y-" & intStartY + intProbeMaxTravel & " F" & intProbeFeedRate	' Execute probe action
		Code "(Probing Y negative axis...)"										' Status bar message
	
		While IsMoving()														' Wait while probe action completes
		Wend
		
		Call SetDro (1, intProbeDiameter/2)										' Set the DRO to half the probe diameter
		Sleep 200																' Wait for DRO to update
		Code "(Y axis is zeroed. Tool at " & intProbeDiameter/2 & ")"			' Status bar message
		
	Case Else
		Code "(Probe action has not been set, set probe action in the script)"	' Status bar message
	End Select	

	Code "F" & intCurrentFeed													' Reinstate prior feed rate

Else
	Code "(Probe is grounded, check connections)"								' Status bar message
End If
