; #FUNCTION# ==========================================================
; Name ..........: THAttackTypes
; Description ...: This file contens the TH attacks
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: AtoZ (2015)
; Modified ......: Barracoda (July 2015), TheMaster 2015-10
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ================================================================

Func SwitchAttackTHType()
	$THusedKing = 0
	$THusedQueen = 0
	AttackTHParseCSV()
EndFunc   ;==>SwitchAttackTHType

Func AttackTHParseCSV($test = False)
	If $debugsetlog = 1 Then Setlog("AttackTHParseCSV start", $COLOR_PURPLE)
	Local $f , $line, $acommand, $command, $isTownHallDestroyed = False
	If FileExists($dirTHSnipesAttacks & "\" & $scmbAttackTHType & ".csv") Then
		$f = FileOpen($dirTHSnipesAttacks & "\" & $scmbAttackTHType & ".csv", 0)
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			If @error = -1 Then ExitLoop
			$acommand = StringSplit($line, "|")
			If $acommand[0] >= 8 Then
				$command = StringStripWS(StringUpper($acommand[1]), 2)
				Select
					Case $command = "TROOP" Or $command = ""
						; discard line
					Case $command = "TEXT"
						If $debugSetLog = 1 Then Setlog(">> SETLOG('" & $acommand[8] & "')")
						SetLog($acommand[8], $COLOR_BLUE)
					Case StringInStr(StringUpper("-Barb-Arch-Giant-Gobl-Wall-Ball-Wiza-Heal-Drag-Pekk-Mini-Hogs-Valk-Gole-Witc-Lava-"), "-" & $command & "-") > 0
						If $debugSetLog = 1 Then Setlog(">> AttackTHGrid($e" & $command & ", Random (" & Int($acommand[2]) & "," & Int($acommand[3]) & ",1), Random(" & Int($acommand[4]) & "," & Int($acommand[5]) & ",1), Random(" & Int($acommand[6]) & "," & Int($acommand[7]) & ",1) )")

						Local $iNbOfSpots
						If Int($acommand[2]) = Int($acommand[3]) Then
							$iNbOfSpots = Int($acommand[2])
						Else
							$iNbOfSpots = Random(Int($acommand[2]), Int($acommand[3]), 1)
						EndIf

						Local $iAtEachSpot
						If Int($acommand[4]) = Int($acommand[5]) Then
							$iAtEachSpot = Int($acommand[4])
						Else
							$iAtEachSpot = Random(Int($acommand[4]), Int($acommand[5]), 1)
						EndIf

						Local $Sleep
						If Int($acommand[6]) = Int($acommand[7]) Then
							$Sleep = Int($acommand[6])
						Else
							$Sleep = Random(Int($acommand[6]), Int($acommand[7]), 1)
						EndIf

						AttackTHGrid(Eval("e" & $command), $iNbOfSpots, $iAtEachSpot, $Sleep, 0)
					Case $command = "WAIT"
						If $debugSetLog = 1 Then Setlog(">> ThSnipeWait(" & Int($acommand[7]) & ")")
						If ThSnipeWait(Int($acommand[7])) Then ; Use seconds not ms, Half of time to check One start and the other halft for check the Resources
							$isTownHallDestroyed = True
							ExitLoop
						EndIf
					Case StringInStr(StringUpper("-King-Queen-Castle-"), "-" & $command & "-") > 0
						If $debugSetLog = 1 Then Setlog(">> AttackTHGrid($e" & $command & ")")
						AttackTHGrid(Eval("e" & $command))
					Case StringInStr(StringUpper("-HSpell-RSpell-"), "-" & $command & "-") > 0
						If $debugSetLog = 1 Then Setlog(">> SpellTHGrid($e" & $command & ")")
						SpellTHGrid(Eval("e" & $command))
					Case StringInStr(StringUpper("-LSpell-"), "-" & $command & "-") > 0
						If $debugSetLog = 1 Then Setlog(">> CastSpell($e" & $command & ",$THx, $THy)")
						CastSpell(Eval("e" & $command), $THx, $THy)
					Case Else
						Setlog("attack row bad, discard: " & $line, $COLOR_RED)
				EndSelect
				If $acommand[8] <> "" And $command <> "TEXT" And $command <> "TROOP" Then
					If $debugSetLog = 1 Then Setlog(">> SETLOG('" & $acommand[8] & "')")
					Setlog($acommand[8], $COLOR_BLUE)
				EndIf
			Else
				If StringStripWS($acommand[1], 2) <> "" Then Setlog("attack row error, discard: " & $line, $COLOR_RED)
			EndIf
			If $debugSetLog = 1 Then Setlog(">> CheckOneStar()")
			If CheckOneStar() Then ExitLoop
		WEnd
		FileClose($f)
	Else
		SetLog("Cannot found THSnipe attack file " & $dirTHSnipesAttacks & "\" & $scmbAttackTHType & ".csv", $color_red)
	EndIf

	If $isTownHallDestroyed And $ichkAttackIfDB = 1 Then TestLootForDB($searchGold, $searchElixir, $searchDark)
EndFunc   ;==>AttackTHParseCSV

Func ThSnipeWait($delay)
	Setlog("Waiting for " & $delay/1000 & " seconds or until the destruction of the town hall")
	Local $ts = TimerInit(), $td = 0
	While $td < $delay 
		_Sleep(1000)
		If CheckOneStar() Then
			Return True
		EndIf
		$td = TimerDiff($ts)
	WEnd
	Return False
EndFunc   ;==>ThSnipeWait

Func TestLootForDB($GoldStart, $ElixirStart, $DarkStart)	
	Setlog ("Checking loot for Greedy mode", $COLOR_BLUE)
	Local $GoldEnd = getGoldVillageSearch(48, 69)
	Local $ElixirEnd = getElixirVillageSearch(48, 69 + 29)
	Local $DarkEnd = getDarkElixirVillageSearch(48, 69 + 57)		
	Local $GoldPercent = Round(100 * ($GoldStart - $GoldEnd) / $GoldStart)
	Local $ElixirPercent = Round(100 * ($ElixirStart - $ElixirEnd) / $ElixirStart)
	Local $DarkPercent = Round(100 * ($DarkStart - $DarkEnd) / $DarkStart)
	Setlog (" - Gold loot % = " & $GoldPercent, $COLOR_ORANGE)
	Setlog (" - Elixir loot % = " & $ElixirPercent, $COLOR_ORANGE)
	Setlog (" - Dark Elixir loot % = " & $DarkPercent, $COLOR_ORANGE)
	
	If $CurCamp > $iMinTroopToAttackDB And ($GoldPercent <= $ipercentTSSuccess Or $ElixirPercent <= $ipercentTSSuccess) Then
		SetLog("Gold & Elixir are mostly in collectors", $COLOR_GREEN, "Lucida Console", 7.5)
		If $SnipeChangedSettings = True Then ; temporaly re-enable DB search
			$iAimTrophy[$DB] = 0
			$iChkMeetOne[$DB] = 1 
		EndIf
		If CompareResources($DB) Then
			SetLog("Resource requirements met for dead base attack", $COLOR_GREEN, "Lucida Console", 7.5)
			If $ichkDBMeetCollOutside = 1 Then ; check for outside collectors if enabled
				If AreCollectorsOutside($iDBMinCollOutsidePercent) Then ; attack dead base if collectors are outside
					SetLog("Collectors are outside.", $COLOR_GREEN)
					$isDeadBase = True ; change settings to dead base attack
					$iMatchMode = $DB
					If $debugDeadBaseImage = 1 Then
						_CaptureRegion()
						_GDIPlus_ImageSaveToFile($hBitmap, @ScriptDir & "\Zombies\" & $Date & " at " & $Time & ".png")
						_WinAPI_DeleteObject($hBitmap)
					EndIf
				Else
					SetLog("Collectors are not outside!", $COLOR_RED)
				EndIf
			Else
				$isDeadBase = True ; change settings to dead base attack
				$iMatchMode = $DB
				If $debugDeadBaseImage = 1 Then
					_CaptureRegion()
					_GDIPlus_ImageSaveToFile($hBitmap, @ScriptDir & "\Zombies\" & $Date & " at " & $Time & ".png")
					_WinAPI_DeleteObject($hBitmap)
				EndIf
			EndIf
		Else
			SetLog("Resource requirements not met for dead base attack", $COLOR_RED, "Lucida Console", 7.5)
		EndIf
		If $SnipeChangedSettings = True Then ; disable DB search after check
			$iAimTrophy[$DB] = 99
			$iChkMeetOne[$DB] = 0 
		EndIf
	EndIf	
	If $ichkDBLightSpell = 1 And $CurLightningSpell > 0 And $DarkPercent <= $ipercentTSSuccess And Number($DarkEnd) >= 1000 Then 
		SetLog("Dark Elixir is mostly in drills and can be zapped", $COLOR_GREEN)
		; indicate dead base for Zap		
		$isDeadBase = True
		$zapBaseMatch = True
	EndIf
	If Not($isDeadBase) Then SetLog("Greedy mode requirements not met", $COLOR_RED)
EndFunc   ;==>CheckLootIfDB