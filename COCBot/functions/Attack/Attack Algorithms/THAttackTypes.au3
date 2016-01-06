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
 	If FileExists($dirTHSnipesAttacks & "\" &$scmbAttackTHType & ".csv") Then
		$f = FileOpen($dirTHSnipesAttacks & "\" &$scmbAttackTHType & ".csv", 0)
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			If @error = -1 Then ExitLoop
			;Setlog("line content: " & $line)
			$acommand = StringSplit($line,"|")
			if $acommand[0] >=8 Then
				$command = StringStripWS (StringUpper( $acommand[1] ),2)
				;   $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $ePSpell, $eESpell, $eHaSpell
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
			If $isTownHallDestroyed = true Then ExitLoop
		WEnd
		FileClose($f)
	Else
		SetLog("Cannot found THSnipe attack file " & $dirTHSnipesAttacks & "\" &$scmbAttackTHType & ".csv" , $color_red)
	EndIf

	If $isTownHallDestroyed = true Then TestLoots($GoldStart, $ElixirStart)
EndFunc   ;==>waitMainScreen

Func TestLoots($GoldStart = 0, $ElixirStart = 0)
	Local $GoldEnd = getGoldVillageSearch(48, 69)
	Local $ElixirEnd = getElixirVillageSearch(48, 69 + 29)
	Local $GoldPerc = 100 * (($GoldStart - $GoldEnd) / $GoldStart)
	Local $ElixirPerc = 100 * ($ElixirStart - $ElixirEnd) / $ElixirStart)
	Setlog ("Gold loot % = " & $GoldPerc)
	Setlog ("Elixir loot % " & $ElixirPerc)
	If $GoldPerc < 5 And $ElixirPerc < 5 Then 		
		Setlog ("Loot is mostly in collectors! Change to DB attack.")
		If $zoomedin = True Then
			ZoomOut()
			$zoomedin = False
			$zCount = 0
			$sCount = 0
		EndIf
		$iMatchMode = $DB
	EndIf	
EndFunc   ;==>AttackTHParseCSV

