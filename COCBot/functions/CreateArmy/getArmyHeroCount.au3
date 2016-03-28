; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyHeroCount
; Description ...: Obtains count of heroes available from Training - Army Overview window
; Syntax ........: getArmyHeroCount()
; Parameters ....:
; Return values .: None
; Author ........: Separated from checkArmyCamp()
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getArmyHeroCount($bOpenArmyWindow = False, $bCloseArmyWindow = False)
	If $debugSetlog = 1 Then SETLOG("Begin getArmyTHeroCount:", $COLOR_PURPLE)

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

	$iHeroAvailable = $HERO_NOHERO  ; reset global hero available data
	$bFullArmyHero = False
	$BarbarianKingAvailable = 0
	$ArcherQueenAvailable = 0
	$GrandWardenAvailable = 0
	
	Local $debugArmyHeroCount = 0 ; put = 1 to make debug images
	Local $capture_x = 440 ; capture a portion of screen starting from ($capture_x,$capture_y)
	Local $capture_y = 420 + $midOffsetY
	Local $capture_width= 200
	Local $capture_height= 150

	_CaptureRegion()
	If $debugArmyHeroCount = 1 Then ; make debug image
		$Date = @MDAY & "." & @MON & "." & @YEAR
		$Time = @HOUR & "." & @MIN & "." & @SEC
		_GDIPlus_ImageSaveToFile($hBitmap, $dirTempDebug & "getArmyHeroCount_" & $Date & " at " & $Time & ".png")
	EndIf

	Local $found = 0
	Local $tolerance = 70
	Local $xpos, $ypos

	; search King
	$xpos = 0
	$ypos = 0
	$found = _ImageSearchArea(@ScriptDir & "\images\HeroesArmy\king.bmp", 1, $capture_x, $capture_y, $capture_x + $capture_width, $capture_y + $capture_height, $xpos, $ypos, $Tolerance)
	If $found = 1 Then
		Setlog(" - Barbarian King available", $color_blue)
		If $debugArmyHeroCount = 1 Then Setlog("- detected in position (" & $xpos & "+" & $capture_x & "," & $ypos & "+" & $capture_y & ")" )
		$iHeroAvailable = BitOR($iHeroAvailable, $HERO_KING)
		$BarbarianKingAvailable = 1
	Else
		If $debugArmyHeroCount = 1 Then Setlog(" - Barbarian King not found", $color_blue)
	EndIf

	; search Queen
	$xpos = 0
	$ypos = 0
	$found = _ImageSearchArea(@ScriptDir & "\images\HeroesArmy\queen.bmp", 1, $capture_x, $capture_y, $capture_x + $capture_width, $capture_y + $capture_height, $xpos, $ypos, $Tolerance)
	If $found = 1 Then
		Setlog(" - Archer Queen available", $color_blue)
		If $debugArmyHeroCount = 1 Then Setlog("- detected in position (" & $xpos & "+" & $capture_x & "," & $ypos & "+" & $capture_y & ")" )
		$iHeroAvailable = BitOR($iHeroAvailable, $HERO_QUEEN)
		$ArcherQueenAvailable = 1
	Else
		If $debugArmyHeroCount = 1 Then Setlog(" - Archer Queen not found", $color_blue)
	EndIf

	; search Grand Warden
	$xpos = 0
	$ypos = 0
	$found = _ImageSearchArea(@ScriptDir & "\images\HeroesArmy\warden.bmp", 1, $capture_x, $capture_y, $capture_x + $capture_width, $capture_y + $capture_height, $xpos, $ypos, $Tolerance)
	If $found = 1 Then
		Setlog(" - Grand Warden available", $color_blue)
		If $debugArmyHeroCount = 1 Then Setlog("- detected in position (" & $xpos & "+" & $capture_x & "," & $ypos & "+" & $capture_y & ")" )
		$iHeroAvailable = BitOR($iHeroAvailable, $HERO_WARDEN)
		$GrandWardenAvailable = 1
	Else
		$xpos = 0
		$ypos = 0
		$found = _ImageSearchArea(@ScriptDir & "\images\HeroesArmy\warden2.bmp", 1, $capture_x, $capture_y, $capture_x + $capture_width, $capture_y + $capture_height, $xpos, $ypos, $Tolerance)
		If $found = 1 Then
			Setlog(" - Grand Warden available", $color_blue)
			If $debugArmyHeroCount = 1 Then Setlog("- detected in position (" & $xpos & "+" & $capture_x & "," & $ypos & "+" & $capture_y & ")" )
			$iHeroAvailable = BitOR($iHeroAvailable, $HERO_WARDEN)
		$GrandWardenAvailable = 1
		Else
			If $debugArmyHeroCount = 1 Then Setlog(" - Grand Warden not found", $color_blue)
		EndIf
	EndIf

	If BitAND($iHeroWait[$DB], $iHeroAvailable) > 0 Or BitAND($iHeroWait[$LB], $iHeroAvailable) > 0 Or _
		($iHeroWait[$DB] = $HERO_NOHERO And $iHeroWait[$DB] = $HERO_NOHERO) Then
		$bFullArmyHero = True
		If $DebugSetlog = 1 Then SetLog("$bFullArmyHero = " & $bFullArmyHero, $COLOR_PURPLE)
	EndIf

	If $DebugSetlog = 1 Then SetLog("Hero Status K|Q|W : " & BitAND($iHeroAvailable, $HERO_KING) & "|" & BitAND($iHeroAvailable, $HERO_QUEEN) & "|" & BitAND($iHeroAvailable, $HERO_WARDEN), $COLOR_PURPLE)

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($iDelaycheckArmyCamp4) Then Return
	EndIf
EndFunc   ;==>getArmyHeroCount