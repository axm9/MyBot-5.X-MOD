; #FUNCTION# ====================================================================================================================
; Name ..........: DrillZapSpell
; Description ...: This file Includes all functions to current GUI
; Syntax ........: DrillZapSpell()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: bushido-21
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CookDrillZapSpell()
	If $iTrainLightSpell = 1 Then
		Local $tempElixir = ""
		
		; Read Resource Values For spell cost Stats
		VillageReport(True, True)
		$tempElixir = $iElixirCurrent

		If WaitforPixel(28, 505 + $bottomOffsetY, 30, 507 + $bottomOffsetY, Hex(0xE4A438, 6), 5, 10) Then
			If $debugSetlog = 1 Then SetLog("Click $aArmyTrainButton", $COLOR_GREEN)
			If IsMainPage() Then Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#0293") ; Army Overview Button
		EndIf
		If _Sleep($iDelayRunBot6) Then Return ; wait for window to open
		If Not (IsTrainPage()) Then Return ; exit if I'm not in train page
		
		$iBarrHere = 0
		While Not (isSpellFactory())
			If Not (IsTrainPage()) Then Return
			_TrainMoveBtn(-1) ; click prev button
			$iBarrHere += 1
			If _Sleep($iDelayTrain3) Then ExitLoop
			If $iBarrHere = 8 Then ExitLoop
		WEnd
		If isSpellFactory() Then
			Local $x = 0
			While 1
				_CaptureRegion()
				If _Sleep($iDelayTrain2) Then Return
				If _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
					Setlog("Spell Factory Full", $COLOR_RED)
					ExitLoop
				Else
					GemClick(252 + ($Spellslot * 105), 354 + $midOffsetY, 1, $iDelayTrain6, "#0290")
					$x = $x + 1
				EndIf
			WEnd
			If $x <> 0 Then SetLog("Created " & $x & " Lightning Spell(s)", $COLOR_BLUE)
		Else
			SetLog("Spell Factory not found...", $COLOR_BLUE)
		EndIf
	EndIf ; End Spell Factory
	
	If _Sleep($iDelayTrain4) Then Return
	ClickP($aAway, 2, $iDelayTrain5, "#0291"); Click away twice with 250ms delay
	$FirstStart = False
	
	; Read Resource Values For spell cost Stats
	If _Sleep($iDelayTrain4) Then Return
	VillageReport(True, True)
	If $tempElixir <> "" And $iElixirCurrent <> "" Then
		$tempElixirSpent = ($tempElixir - $iElixirCurrent)
		$iTrainCostElixir += $tempElixirSpent
		$iElixirTotal -= $tempElixirSpent
	EndIf
EndFunc