; #FUNCTION# ====================================================================================================================
; Name ..........: DEDrillSearch
; Description ...: Searches for the DE Drills in base, and returns; X&Y location, Bldg Level
; Syntax ........: DEDrillSearch([$bReTest = False])
; Parameters ....: $bReTest             - [optional] a boolean value. Default is False.
; Return values .: $aDrills Array with data on Dark Elixir Drills found in search
; Author ........: McSlither (May 2016)
; Modified ......:
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func DEDrillSearch($bReTest = False)
	If $ichkDBLightSpell <> 1 Then Return False
	Local $aDrills[4][5] = [[-1, -1, -1, -1, 0], [-1, -1, -1, -1, 0], [-1, -1, -1, -1, 0], [-1, -1, -1, -1, 0]] ; [XCoord, YCoord, Level, AvailDE, #Zapped]
	Local $pixel[2], $result, $listPixelByLevel, $pixelWithLevel, $level, $pixelStr
	$numDEDrill = 0

	ZoomOut()	
	_CaptureRegion2()
	$result = GetLocationDarkElixirWithLevel() ; Get the results of a drill search
	If $debugsetlog = 1 Then Setlog("Drill search $result = " & $result, $COLOR_PURPLE) ; Debug
	
	$listPixelByLevel = StringSplit($result, "~") ; Split DLL return into an array
	If $listPixelByLevel[1] <> "" Then $numDEDrill = $listPixelByLevel[0]
	SetLog("Total No. of Dark Elixir Drills found = " & $numDEDrill, $COLOR_FUCHSIA)
	If $debugsetlog = 1 Then
		For $i = 1 To $numDEDrill
			Setlog("Drill search $listPixelByLevel[" & $i & "] = " & $listPixelByLevel[$i], $COLOR_PURPLE)
		Next
	EndIf

	If $numDEDrill > 0 Then		
		$iNbrOfDetectedDrillsForZap += $numDEDrill
		For $i = 0 To $numDEDrill
			$pixelWithLevel = StringSplit($listPixelByLevel[$i], "#")
			If @error Then ContinueLoop ; If the string delimiter is not found, then try next string.

			$level = $pixelWithLevel[1]
			$pixelStr = StringSplit($pixelWithLevel[2], "-")

			Local $pixel[2] = [$pixelStr[1], $pixelStr[2]]
			If isInsideDiamond($pixel)  Then
				$aDrills[$i][0] = Number($pixel[0])
				$aDrills[$i][1] = Number($pixel[1])
				$aDrills[$i][2] = Number($level)
				$aDrills[$i][3] = $DrillLevelHold[Number($level) - 1]
				If $debugsetlog = 1 Then SetLog("Dark Elixir Drill: [" & $aDrills[$i][0] & "," & $aDrills[$i][1] & "], Level: " & $aDrills[$i][2] & " " & $aDrills[$i][3], $COLOR_BLUE)
			Else
				If $debugsetlog = 1 Then SetLog("Dark Elixir Drill: [" & $pixel[0] & "," & $pixel[1] & "], Level: " & $level, $COLOR_PURPLE)
				If $debugsetlog = 1 Then SetLog("Found Drill Drill with Invalid Location.", $COLOR_RED)
			EndIf
		Next
	EndIf
	Return $aDrills
EndFunc   ;==>DEDrillSearch