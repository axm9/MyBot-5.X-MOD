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
	Local $GoldStart = getGoldVillageSearch(48, 69)
	Local $ElixirStart = getElixirVillageSearch(48, 69 + 29)
	Local $DarkStart = getDarkElixirVillageSearch(48, 69 + 57)
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
						If $debugSetLog = 1 Then Setlog(">> SETLOG(""" & $acommand[8] & """)")
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
						If $debugSetLog = 1 Then Setlog(">> GoldElixirChangeThSnipes(" & Int($acommand[7]) & ") ")
						If ThSnipeWait(Int($acommand[7])) Then ; Use seconds not ms , Half of time to check One start and the other halft for check the Resources
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
					If $debugSetLog = 1 Then Setlog(">> SETLOG(""" & $acommand[8] & """)")
					SETLOG($acommand[8], $COLOR_BLUE)
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

	If $isTownHallDestroyed = True Then TestLoots($GoldStart, $ElixirStart, $DarkStart)
	GoldElixirChangeThSnipes($iDelayReturnHome1) ; check for resource change after TH snipe
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

Func TestLoots($GoldStart = 0, $ElixirStart = 0, $DarkStart = 0)
	If $ichkAttackIfDB = 1 Then
		Local $raidCollectors = 0, $atkGold = 0, $atkElixir = 0, $atkDark = 0
		Local $GoldEnd = getGoldVillageSearch(48, 69)
		Local $ElixirEnd = getElixirVillageSearch(48, 69 + 29)
		Local $DarkEnd = getDarkElixirVillageSearch(48, 69 + 57)		
		Local $GoldPercent = 100 * ($GoldStart - $GoldEnd) / $GoldStart
		Local $ElixirPercent = 100 * ($ElixirStart - $ElixirEnd) / $ElixirStart
		Local $DarkPercent = 100 * ($DarkStart - $DarkEnd) / $DarkStart
		Setlog ("Gold loot % = " & $GoldPercent)
		Setlog ("Elixir loot % " & $ElixirPercent)
		Setlog ("Dark Elixir loot % " & $DarkPercent)
		If $GoldPercent < $ipercentTSSuccess And $GoldEnd > 100000 Then 
			$atkGold = 1
			$raidCollectors += 1
		EndIf
		If $ElixirPercent < $ipercentTSSuccess And $ElixirEnd > 100000 Then 
			$atkElixir = 1
			$raidCollectors += 1
		EndIf
		If $DarkPercent < $ipercentTSSuccess And $DarkEnd > 1000 Then 
			$atkDark = 1
			$raidCollectors += 1
		EndIf
		
		If ($raidCollectors <> 0) Then
			RaidCollectors($GoldEnd, $ElixirEnd)
			;RaidCollectorsSmart($atkGold, $atkElixir, $atkDark)
		EndIf
	EndIf
EndFunc   ;==>AttackTHParseCSV

Func RaidCollectors($GoldEnd = 0, $ElixirEnd = 0)
	Local $attackUsed = False
	Setlog ("Loot is mostly in collectors!")	
	
	; temporarily store original settings
	$tempMatchMode = $iMatchMode
	$tempDeployMode = $iChkDeploySettings[$DB]

	; change settings to dead base attack deploying
	$iMatchMode = $DB
	$iChkDeploySettings[$DB] = 4 ; FF deployment
	
	; attack dead base if have enough troops and there's Gold and Elixir to raid
	If $CurCamp > $iMinTroopToAttackDB And $GoldEnd > 100000 And $ElixirEnd > 100000 Then 	
		Setlog ("Attacking collectors!")		
		PrepareAttack($DB)
		Attack()
		$attackUsed = True
		; wait until there's loot change
		While GoldElixirChangeEBO()
			If _Sleep($iDelayReturnHome1) Then Return
		WEnd
	EndIf	
	
	; Zap DE drill if needed
	If DEDropSmartSpell() <> False Then $attackUsed = True
	
	; reset original settings
	$iMatchMode = $tempMatchMode
	$iChkDeploySettings[$DB] = $tempDeployMode
	Return $attackUsed
EndFunc   ;==>RaidCollectors

Func RaidCollectorsSmart($atkGold = 1, $atkElixir = 1, $atkDark = 1, $GoldEnd = 0, $ElixirEnd = 0)
	Local $attackUsed = False
	Setlog ("Loot is mostly in collectors!")	
	
	; temporarily store original settings
	$tempMatchMode = $iMatchMode
	$tempDeployMode = $iChkDeploySettings[$DB]
	$tempChkRedArea = $iChkRedArea[$DB]
	$tempSmartDeploy = $iCmbSmartDeploy[$DB]
	$tempChkAttackGold = $iChkSmartAttack[$DB][0]
	$tempChkAttackElixir = $iChkSmartAttack[$DB][1]
	$tempChkAttackDark = $iChkSmartAttack[$DB][2]

	; change settings to dead base attack deploying near collectors
	$iMatchMode = $DB
	$iChkDeploySettings[$DB] = 3 ; attack all sides
	$iChkRedArea[$DB] = 1 ; smart attack
	$iCmbSmartDeploy[$DB] = 1 ; Troops, then Sides
	; smart attack dropping near collectors
	$iChkSmartAttack[$DB][0] = $atkGold
	$iChkSmartAttack[$DB][1] = $atkElixir 
	$iChkSmartAttack[$DB][2] = $atkDark
	
	; attack dead base if have enough troops and there's gold or elixir to raid
	If $CurCamp > $iMinTroopToAttackDB And $GoldEnd > 100000 And $ElixirEnd > 100000 Then 	
		Setlog ("Attacking collectors!")		
		PrepareAttack($DB)
		Attack()
		$attackUsed = True
		; wait until there's loot change
		While GoldElixirChangeEBO()
			If _Sleep($iDelayReturnHome1) Then Return
		WEnd
	EndIf	
	
	; Zap DE drill if needed
	If DEDropSmartSpell() <> False Then $attackUsed = True
	
	; reset original settings
	$iMatchMode = $tempMatchMode
	$iChkDeploySettings[$DB] = $tempDeployMode
	$iChkRedArea[$DB] = $tempChkRedArea
	$iCmbSmartDeploy[$DB] = $tempSmartDeploy
	$iChkSmartAttack[$DB][0] = $tempChkAttackGold
	$iChkSmartAttack[$DB][1] = $tempChkAttackElixir
	$iChkSmartAttack[$DB][2] = $tempChkAttackDark
	
	Return $attackUsed
EndFunc   ;==>RaidCollectorsSmart