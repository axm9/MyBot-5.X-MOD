; #FUNCTION# ==========================================================
; Name ..........: THAttackTypes
; Description ...: This file contens the TH attacks
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: AtoZ (2015)
; Modified ......: Barracoda (July 2015), TheMaster 2015-10
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ================================================================

Func SwitchAttackTHType()
	$THusedKing= 0
	$THusedQueen=0
	AttackTHParseCSV()
EndFunc   ;==>SwitchAttackTHType

Func AttackTHParseCSV($test=False)
	If $debugsetlog=1 Then Setlog("AttackTHParseCSV start",$COLOR_PURPLE)
	Local $f , $line, $acommand, $command, $isTownHallDestroyed = false
	Local $GoldStart = getGoldVillageSearch(48, 69)
	Local $ElixirStart = getElixirVillageSearch(48, 69 + 29)
	Local $DarkStart = getDarkElixirVillageSearch(48, 69 + 57)
 	If FileExists($dirTHSnipesAttacks & "\" &$scmbAttackTHType & ".csv") Then
		$f = FileOpen($dirTHSnipesAttacks & "\" &$scmbAttackTHType & ".csv", 0)
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			If @error = -1 Then ExitLoop
			$acommand = StringSplit($line,"|")
			If $acommand[0] >=8 Then
				$command = StringStripWS (StringUpper( $acommand[1] ),2)
				Select
					Case $command = "TROOP"  or $command = ""
						;Setlog("<<<<discard line>>>>")
					Case $command = "TEXT"
						If $test = True Then
							Setlog(">> SETLOG(""" & $acommand[8] & """)")
						Else
							SetLog($acommand[8] ,$COLOR_BLUE)
						EndIf
					Case StringInStr(StringUpper("-Barb-Arch-Giant-Gobl-Wall-Ball-Wiza-Heal-Drag-Pekk-Mini-Hogs-Valk-Gole-Witc-Lava-"), "-" & $command & "-") >0
						If $test = True Then
							Setlog(">> AttackTHGrid($e" &$command&", Random (" &  Int($acommand[2])&"," & int($acommand[3])&",1), Random("& int($acommand[4])&"," & int($acommand[5])&",1), Random(" & int($acommand[6]) &"," & int($acommand[7])& ",1) )" )
						Else
 							AttackTHGrid(Eval("e" &$command ) , Random ( Int($acommand[2]), Int($acommand[3]),1), Random( int($acommand[4]), int($acommand[5]),1), Random( int($acommand[6]) , int($acommand[7]),1) )
						EndIf
					Case $command = "WAIT"
						If $test = True Then
							Setlog(">> ThSnipeWait(" &int($acommand[7])  & ") " )
						Else
							$isTownHallDestroyed = ThSnipeWait( Int($acommand[7]) )
						EndIf
					Case StringInStr(StringUpper("-King-Queen-Castle-"), "-" & $command & "-") >0
						If $test = True Then
							Setlog(">> AttackTHGrid($e"&$command & ")" )
						Else
							AttackTHGrid( Eval("e"&$command ) )
						EndIf
					Case StringInStr(StringUpper("-HSpell-RSpell-"), "-" & $command & "-") >0
						If $test = True Then
							Setlog(">> SpellTHGrid($e"&$command & ")" )
						Else
							SpellTHGrid( Eval("e"& $command ) )
						EndIf
					Case StringInStr(StringUpper("-LSpell-"), "-" & $command & "-") >0
						If $test = True Then
							Setlog(">> CastSpell($e"&$command & ",$THx, $THy)" )
						Else
							CastSpell(Eval("e"&$command) ,$THx, $THy )
						EndIf
					Case Else
						Setlog("attack row bad, discard: " & $line,$COLOR_RED)
				EndSelect
				If $acommand[8] <> "" And $command <> "TEXT"  And $command <>"TROOP" Then
					If $test = True Then
						Setlog(">> SETLOG(""" & $acommand[8] & """)")
					Else
						SETLOG( $acommand[8] ,$COLOR_BLUE)
					EndIf
				EndIf
			Else
				if StringStripWS( $acommand[1],2  ) <>"" Then  Setlog("attack row error, discard: " & $line,$COLOR_RED)
			EndIf
			If $isTownHallDestroyed = True Then ExitLoop
		WEnd
		FileClose($f)
	Else
		SetLog("Cannot found THSnipe attack file " & $dirTHSnipesAttacks & "\" &$scmbAttackTHType & ".csv" , $color_red)
	EndIf

	If $isTownHallDestroyed = True Then TestLoots($GoldStart, $ElixirStart, $DarkStart)
	While GoldElixirChangeEBO()
		If _Sleep($iDelayReturnHome1) Then Return
	WEnd
EndFunc   ;==>waitMainScreen

Func TestLoots($GoldStart = 0, $ElixirStart = 0, $DarkStart = 0)
	If $ichkAttackIfDB = 1 Then
		Local $raidCollector = 0, $atkGold = 0, $atkElixir = 0, $atkDark = 0
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
			$raidCollector += 1
		EndIf
		If $ElixirPercent < $ipercentTSSuccess And $ElixirEnd > 100000 Then 
			$atkElixir = 1
			$raidCollector += 1
		EndIf
		If $DarkPercent < $ipercentTSSuccess And $DarkEnd > 1000 Then 
			$atkDark = 1
			$raidCollector += 1
		EndIf
		
		If ($raidCollector > 1) Then
			RaidCollectors($atkGold, $atkElixir, $atkDark)
		EndIf
	EndIf
EndFunc   ;==>AttackTHParseCSV

Func RaidCollectors($atkGold = 1, $atkElixir = 1, $atkDark = 1)
	Setlog ("Loot is mostly in collectors!")
	
	; temporarily store original settings
	$tempMatchMode = $iMatchMode
	$tempChkRedArea = $iChkRedArea[$DB]
	$tempSmartDeploy = $iCmbSmartDeploy[$DB]
	$tempChkAttackGold = $iChkSmartAttack[$DB][0]
	$tempChkAttackElixir = $iChkSmartAttack[$DB][1]
	$tempChkAttackDark = $iChkSmartAttack[$DB][2]
	$tempDeployMode = $iChkDeploySettings[$DB]

	; change settings to dead base attack deploying near collectors
	$iMatchMode = $DB
	$iChkRedArea[$DB] = 1 ; smart attack
	$iCmbSmartDeploy[$DB] = 0 ; Sides, then Troops
	; test smart attack without dropping near collectors
	;$iChkSmartAttack[$DB][0] = $atkGold
	;$iChkSmartAttack[$DB][1] = $atkElixir
	;$iChkSmartAttack[$DB][2] = $atkDark
	$iChkDeploySettings[$DB] = 3 ; attack all sides
	
	$GoldEnd = getGoldVillageSearch(48, 69)
	$ElixirEnd = getElixirVillageSearch(48, 69 + 29)	
	; attack dead base if have enough troops
	If $CurCamp > $iMinTroopToAttackDB Then 	
		Setlog ("Attacking collectors!")
		PrepareAttack($iMatchMode)
		Attack()
	EndIf
	
	; wait until there's loot change
	While GoldElixirChangeEBO()
		If _Sleep($iDelayReturnHome1) Then Return
	WEnd
	
	DEDropSmartSpell()
	
	; reset original settings
	$iMatchMode = $tempMatchMode
	$iChkRedArea[$DB] = $tempChkRedArea
	$iCmbSmartDeploy[$DB] = $tempSmartDeploy
	$iChkSmartAttack[$DB][0] = $tempChkAttackGold
	$iChkSmartAttack[$DB][1] = $tempChkAttackElixir
	$iChkSmartAttack[$DB][2] = $tempChkAttackDark
	$iChkDeploySettings[$DB] = $tempDeployMode
EndFunc   ;==>RaidCollectors