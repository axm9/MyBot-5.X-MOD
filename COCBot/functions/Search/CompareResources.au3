; #FUNCTION# ====================================================================================================================
; Name ..........: CompareResources
; Description ...: Compaires Resources while searching for a village to attack
; Syntax ........: CompareResources()
; Parameters ....:
; Return values .: True if compaired resources match the search conditions, False if not
; Author ........: (2014)
; Modified ......: AtoZ, Hervidero (2015), kaganus (June 2015, August 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: VillageSearch, GetResources
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CompareResources($pMode) ; Compares resources and returns true if conditions meet, otherwise returns false
	If $iChkSearchReduction = 1 Then
		If ($iChkEnableAfter[$pMode] = 0 And $SearchCount <> 0 And Mod($SearchCount, $ReduceCount) = 0) Or ($iChkEnableAfter[$pMode] = 1 And $SearchCount - $iEnableAfterCount[$pMode] > 0 And Mod($SearchCount - $iEnableAfterCount[$pMode], $ReduceCount) = 0) Then
			If $iAimGold[$pMode] - $ReduceGold >= 0 Then $iAimGold[$pMode] -= $ReduceGold
			If $iAimElixir[$pMode] - $ReduceElixir >= 0 Then $iAimElixir[$pMode] -= $ReduceElixir
			If $iAimDark[$pMode] - $ReduceDark >= 0 Then $iAimDark[$pMode] -= $ReduceDark
			If $iAimTrophy[$pMode] - $ReduceTrophy >= 0 Then $iAimTrophy[$pMode] -= $ReduceTrophy
			If $iAimGoldPlusElixir[$pMode] - $ReduceGoldPlusElixir >= 0 Then $iAimGoldPlusElixir[$pMode] -= $ReduceGoldPlusElixir

			If $iCmbMeetGE[$pMode] = 2 Then
				SetLog("Aim:           [G+E]:" & StringFormat("%7s", $iAimGoldPlusElixir[$pMode]) & " [D]:" & StringFormat("%5s", $iAimDark[$pMode]) & " [T]:" & StringFormat("%2s", $iAimTrophy[$pMode]) & $iAimTHtext[$pMode] & " for: " & $sModeText[$pMode], $COLOR_GREEN, "Lucida Console", 7.5)
			Else
				SetLog("Aim: [G]:" & StringFormat("%7s", $iAimGold[$pMode]) & " [E]:" & StringFormat("%7s", $iAimElixir[$pMode]) & " [D]:" & StringFormat("%5s", $iAimDark[$pMode]) & " [T]:" & StringFormat("%2s", $iAimTrophy[$pMode]) & $iAimTHtext[$pMode] & " for: " & $sModeText[$pMode], $COLOR_GREEN, "Lucida Console", 7.5)
			EndIf
		EndIf
	EndIf
	
	Local $G = (Number($searchGold) >= Number($iAimGold[$pMode])), $E = (Number($searchElixir) >= Number($iAimElixir[$pMode])), $D = (Number($searchDark) >= Number($iAimDark[$pMode])), $T = (Number($searchTrophy) >= Number($iAimTrophy[$pMode])), $GPE = ((Number($searchGold) + Number($searchElixir)) >= Number($iAimGoldPlusElixir[$pMode]))
	
	Local $THL = -1, $THLO = -1

	For $i = 0 To 5
		If $searchTH = $THText[$i] Then $THL = $i
	Next

	Switch $THLoc
		Case "In"
			$THLO = 0
		Case "Out"
			$THLO = 1
	EndSwitch

	$SearchTHLResult = 0
	If $THL > -1 And $THL <= $YourTH And $searchTH <> "-" Then $SearchTHLResult = 1

	If $iChkMeetOne[$pMode] = 1 Then
		If $iCmbMeetGE[$pMode] = 0 Then
			If $G = True And $E = True Then
				If $DebugSetlog = 1 Then Setlog("Gold and Elixir requirement met for mode " & $pMode, $COLOR_GREEN)
				Return True
			EndIf
		EndIf

		If $iCmbMeetGE[$pMode] = 1 Then
			If $G = True Or $E = True Then
				If $DebugSetlog = 1 Then Setlog("Gold or Elixir requirement met for mode " & $pMode, $COLOR_GREEN)
				Return True
			EndIf
		EndIf

		If $iCmbMeetGE[$pMode] = 2 Then
			If $GPE = True Then
				If $DebugSetlog = 1 Then Setlog("Gold + Elixir requirement met for mode " & $pMode, $COLOR_GREEN)
				Return True
			EndIf
		EndIf

		If $iChkMeetDE[$pMode] = 1 Then
			If $D = True Then
				If $DebugSetlog = 1 Then Setlog("Dark Elixir requirement met for mode " & $pMode, $COLOR_GREEN)
				Return True
			EndIf
		EndIf

		If $iChkMeetTrophy[$pMode] = 1 Then
			If $T = True Then
				If $DebugSetlog = 1 Then Setlog("Trophy requirement met for mode " & $pMode, $COLOR_GREEN)
				Return True
			EndIf
		EndIf

		If $iChkMeetTH[$pMode] = 1 Then
			If $THL <> -1 And $THL <= $iCmbTH[$pMode] Then
				If $DebugSetlog = 1 Then Setlog("Townhall level requirement met for mode " & $pMode, $COLOR_GREEN)
				Return True
			EndIf
		EndIf

		If $iChkMeetTHO[$pMode] = 1 Then
			If $THLO = 1 Then
				If $DebugSetlog = 1 Then Setlog("Townhall outside requirement met for mode " & $pMode, $COLOR_GREEN)
				Return True
			EndIf
		EndIf

		Return False
	Else
		If $iCmbMeetGE[$pMode] = 0 Then
			If $G = False Or $E = False Then
				If $DebugSetlog = 1 Then Setlog("Gold or Elixir requirement not met for mode " & $pMode, $COLOR_RED)
				Return False
			EndIf
		EndIf

		If $iCmbMeetGE[$pMode] = 1 Then
			If $G = False And $E = False Then
				If $DebugSetlog = 1 Then Setlog("Gold and Elixir requirement not met for mode " & $pMode, $COLOR_RED)
				Return False
			EndIf
		EndIf

		If $iCmbMeetGE[$pMode] = 2 Then
			If $GPE = False Then
				If $DebugSetlog = 1 Then Setlog("Gold + Elixir requirement not met for mode " & $pMode, $COLOR_RED)
				Return False
			EndIf
		EndIf

		If $iChkMeetDE[$pMode] = 1 Then
			If $D = False Then
				If $DebugSetlog = 1 Then Setlog("Dark Elixir requirement not met for mode " & $pMode, $COLOR_RED)
				Return False
			EndIf
		EndIf

		If $iChkMeetTrophy[$pMode] = 1 Then
			If $T = False Then
				If $DebugSetlog = 1 Then Setlog("Trophy requirement not met for mode " & $pMode, $COLOR_RED)
				Return False
			EndIf
		EndIf

		If $iChkMeetTH[$pMode] = 1 Then
			If $THL = -1 Or $THL > $iCmbTH[$pMode] Then
				If $DebugSetlog = 1 Then Setlog("Townhall level requirement not met for mode " & $pMode, $COLOR_RED)
				Return False
			EndIf
		EndIf

		If $iChkMeetTHO[$pMode] = 1 Then
			If $THLO <> 1 Then
				If $DebugSetlog = 1 Then Setlog("Townhall outside requirement not met for mode " & $pMode, $COLOR_RED)
				Return False
			EndIf
		EndIf
	EndIf
	Return True
EndFunc   ;==>CompareResources