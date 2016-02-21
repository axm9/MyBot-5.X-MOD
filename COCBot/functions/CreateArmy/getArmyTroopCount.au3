; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyTroopCount
; Description ...: Reads current quanitites/type of troops from Training - Army Overview window, updates $CurXXXX and $aDTtroopsToBeUsed values
; Syntax ........: getArmyTroopCount()
; Parameters ....: $bOpenArmyWindow     - [optional] a boolean value. Default is False.
;                  $bCloseArmyWindow    - [optional] a boolean value. Default is False.
; Return values .: None
; Author ........: Separated from checkArmyCamp()
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $SlotInArmyBarb = -1, $SlotInArmyArch = -1, $SlotInArmyGiant = -1, $SlotInArmyGobl = -1, $SlotInArmyWall = -1, $SlotInArmyBall = -1, $SlotInArmyWiza = -1, $SlotInArmyHeal = -1
Global $SlotInArmyMini = -1, $SlotInArmyHogs = -1, $SlotInArmyValk = -1, $SlotInArmyGole = -1, $SlotInArmyWitc = -1, $SlotInArmyLava = -1, $SlotInArmyDrag = -1, $SlotInArmyPekk = -1

Func getArmyTroopCount($bOpenArmyWindow = False, $bCloseArmyWindow = False)
	If $debugSetlog = 1 Then Setlog("Begin getArmyTroopCount", $COLOR_PURPLE)

	If $bOpenArmyWindow = False And IsTrainPage() = False Then ; check for train page
		SetError(1)
		Return ; not open, not requested to be open - error.
	ElseIf $bOpenArmyWindow = True Then
		If openArmyOverview() = False Then
			SetError(2)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep($iDelaycheckArmyCamp5) Then Return
	EndIf

	Local $FullTemp = ""
	Local $TroopName = 0
	Local $TroopQ = 0
	Local $TroopTypeT = ""

	_WinAPI_DeleteObject($hBitmapFirst)
	Local $hBitmapFirst = _CaptureRegion2(120, 165 + $midOffsetY, 740, 220 + $midOffsetY)
	If _Sleep($iDelaycheckArmyCamp5) Then Return
	If $debugSetlog = 1 Then SetLog("Calling MBRfunctions.dll/searchIdentifyTroopTrained ", $COLOR_PURPLE)

	$FullTemp = DllCall($hFuncLib, "str", "searchIdentifyTroopTrained", "ptr", $hBitmapFirst)
	If _Sleep($iDelaycheckArmyCamp6) Then Return ; 10ms improve pause button response
	If $debugSetlog = 1 Then
		If IsArray($FullTemp) Then
			SetLog("Dll return $FullTemp: " & $FullTemp[0], $COLOR_PURPLE)
		Else
			SetLog("Dll return $FullTemp: ERROR " & $FullTemp, $COLOR_PURPLE)
		EndIf
	EndIf

	If IsArray($FullTemp) Then
		$TroopTypeT = StringSplit($FullTemp[0], "|")
	EndIf

	For $i = 0 To UBound($TroopName) - 1 ; Reset the variables
		Assign(("SlotInArmy" & $TroopName[$i]), -1)
	Next

	For $i = 0 To UBound($TroopDarkName) - 1 ; Reset the variables
		Assign(("SlotInArmy" & $TroopDarkName[$i]), -1)
	Next

	For $i = 0 To UBound($aDTtroopsToBeUsed, 1) - 1 ; Reset the variables
		$aDTtroopsToBeUsed[$i][1] = 0
	Next

	If IsArray($TroopTypeT) And $TroopTypeT[1] <> "" Then
		For $i = 1 To $TroopTypeT[0]
			$TroopName = "Unknown"
			$TroopQ = "0"
			If _sleep($iDelaycheckArmyCamp1) Then Return
			Local $Troops = StringSplit($TroopTypeT[$i], "#", $STR_NOCOUNT)

			If IsArray($Troops) And $Troops[0] <> "" Then
				Switch $Troops[0]
					Case $eBarb
						$TroopQ = $Troops[2]
						$TroopName = "Barbarians"
						$aDTtroopsToBeUsed[0][1] = $Troops[2]
						If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eBarb) Then
							$CurBarb = -($TroopQ)
							$SlotInArmyBarb = $i - 1
						EndIf
					Case $eArch
						$TroopQ = $Troops[2]
						$TroopName = "Archers"
						$aDTtroopsToBeUsed[1][1] = $Troops[2]
						If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eArch) Then
							$CurArch = -($TroopQ)
							$SlotInArmyArch = $i - 1
						EndIf
					Case $eGiant
						$TroopQ = $Troops[2]
						$TroopName = "Giants"
						$aDTtroopsToBeUsed[2][1] = $Troops[2]
						If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eGiant) Then
							$CurGiant = -($TroopQ)
							$SlotInArmyGiant = $i - 1
						EndIf
					Case $eGobl
						$TroopQ = $Troops[2]
						$TroopName = "Goblins"
						$aDTtroopsToBeUsed[4][1] = $Troops[2]
						If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eGobl) Then
							$CurGobl = -($TroopQ)
							$SlotInArmyGobl = $i - 1
						EndIf
					Case $eWall
						$TroopQ = $Troops[2]
						$TroopName = "Wallbreakers"
						$aDTtroopsToBeUsed[3][1] = $Troops[2]
						If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eWall) Then
							$CurWall = -($TroopQ)
							$SlotInArmyWall = $i - 1
						EndIf
					Case $eBall
						$TroopQ = $Troops[2]
						$TroopName = "Balloons"
						If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eBall) Then
							$CurBall = -($TroopQ)
							$SlotInArmyBall = $i - 1
						EndIf
					Case $eHeal
						$TroopQ = $Troops[2]
						$TroopName = "Healers"
						If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eHeal) Then
							$CurHeal = -($TroopQ)
							$SlotInArmyHeal = $i - 1
						EndIf
					Case $eWiza
						$TroopQ = $Troops[2]
						$TroopName = "Wizards"
						If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eWiza) Then
							$CurWiza = -($TroopQ)
							$SlotInArmyWiza = $i - 1
						EndIf
					Case $eDrag
						$TroopQ = $Troops[2]
						$TroopName = "Dragons"
						If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eDrag) Then
							$CurDrag = -($TroopQ)
							$SlotInArmyDrag = $i - 1
						EndIf
					Case $ePekk
						$TroopQ = $Troops[2]
						$TroopName = "Pekkas"
						If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($ePekk) Then
							$CurPekk = -($TroopQ)
							$SlotInArmyPekk = $i - 1
						EndIf
					Case $eMini
						$TroopQ = $Troops[2]
						$TroopName = "Minions"
						$aDTtroopsToBeUsed[5][1] = $Troops[2]
						If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eMini) Then
							$CurMini = -($TroopQ)
							$SlotInArmyMini = $i - 1
						EndIf
					Case $eHogs
						$TroopQ = $Troops[2]
						$TroopName = "Hog Riders"
						If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eHogs) Then
							$CurHogs = -($TroopQ)
							$SlotInArmyHogs = $i - 1
						EndIf
					Case $eValk
						$TroopQ = $Troops[2]
						$TroopName = "Valkyries"
						If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eValk) Then
							$CurValk = -($TroopQ)
							$SlotInArmyValk = $i - 1
						EndIf
					Case $eGole
						$TroopQ = $Troops[2]
						$TroopName = "Golems"
						If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eGole) Then
							$CurGole = -($TroopQ)
							$SlotInArmyGole = $i - 1
						EndIf
					Case $eWitc
						$TroopQ = $Troops[2]
						$TroopName = "Witches"
						If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eWitc) Then
							$CurWitc = -($TroopQ)
							$SlotInArmyWitc = $i - 1
						EndIf
					Case $eLava
						$TroopQ = $Troops[2]
						$TroopName = "Lava Hounds"
						If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eLava) Then
							$CurLava = -($TroopQ)
							$SlotInArmyLava = $i - 1
						EndIf
				EndSwitch
				If $TroopQ <> 0 Then SetLog(" - No. of " & $TroopName & ": " & $TroopQ)
			EndIf
		Next
	EndIf

	If Not $fullArmy And $FirstStart Then
		$ArmyComp = $CurCamp
	EndIf

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($iDelaycheckArmyCamp4) Then Return
	EndIf
EndFunc   ;==>getArmyTroopCount