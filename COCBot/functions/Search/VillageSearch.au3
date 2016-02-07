; #FUNCTION# ====================================================================================================================
; Name ..........: VillageSearch
; Description ...: Searches for a village that until meets conditions
; Syntax ........: VillageSearch()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #6
; Modified ......: kaganus (Jun/Aug 2015), Sardo 2015-07, KnowJack(Aug 2015) , The Master (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func VillageSearch() ;Control for searching a village that meets conditions
	Local $Result
	Local $logwrited = False
	$iSkipped = 0

	If $debugDeadBaseImage = 1 Then
		If DirGetSize(@ScriptDir & "\SkippedZombies\") = -1 Then DirCreate(@ScriptDir & "\SkippedZombies\")
		If DirGetSize(@ScriptDir & "\Zombies\") = -1 Then DirCreate(@ScriptDir & "\Zombies\")
	EndIf

	If $Is_ClientSyncError = False Then
		For $i = 0 To $iModeCount - 1
			$iAimGold[$i] = $iMinGold[$i]
			$iAimElixir[$i] = $iMinElixir[$i]
			$iAimGoldPlusElixir[$i] = $iMinGoldPlusElixir[$i]
			$iAimDark[$i] = $iMinDark[$i]
			$iAimTrophy[$i] = $iMinTrophy[$i]
		Next
	EndIf

	_WinAPI_EmptyWorkingSet(WinGetProcess($Title)) ; Reduce Working Set of Android Process
	_WinAPI_EmptyWorkingSet(@AutoItPID) ; Reduce Working Set of Bot

	If _Sleep($iDelayVillageSearch1) Then Return
	If $Restart = True Then Return ; exit func
	For $x = 0 To $iModeCount - 1
		If $x = $iCmbSearchMode Or $iCmbSearchMode = 2 Then
			If Not ($Is_SearchLimit) Then SetLog(_PadStringCenter(" Searching For " & $sModeText[$x] & " ", 54, "="), $COLOR_BLUE)

			Local $MeetGxEtext = "", $MeetGorEtext = "", $MeetGplusEtext = "", $MeetDEtext = "", $MeetTrophytext = "", $MeetTHtext = "", $MeetTHOtext = "", $MeetWeakBasetext = "", $EnabledAftertext = ""

			If Not ($Is_SearchLimit) Then SetLog(_PadStringCenter(" SEARCH CONDITIONS ", 50, "~"), $COLOR_BLUE)

			If $iCmbMeetGE[$x] = 0 Then $MeetGxEtext = "Meet: Gold and Elixir"
			If $iCmbMeetGE[$x] = 1 Then $MeetGorEtext = "Meet: Gold or Elixir"
			If $iCmbMeetGE[$x] = 2 Then $MeetGplusEtext = "Meet: Gold + Elixir"
			If $iChkMeetDE[$x] = 1 Then $MeetDEtext = ", Dark"
			If $iChkMeetTrophy[$x] = 1 Then $MeetTrophytext = ", Trophy"
			If $iChkMeetTH[$x] = 1 Then $MeetTHtext = ", Max TH " & $iMaxTH[$x] ;$icmbTH
			If $iChkMeetTHO[$x] = 1 Then $MeetTHOtext = ", TH Outside"
			If $iChkWeakBase[$x] = 1 Then $MeetWeakBasetext = ", Weak Base(Mortar: " & $iCmbWeakMortar[$x] & ", WizTower: " & $iCmbWeakWizTower[$x] & ")"
			If $iChkEnableAfter[$x] = 1 Then $EnabledAftertext = ", Enabled after " & $iEnableAfterCount[$x] & " searches"

			If Not ($Is_SearchLimit) Then SetLog($MeetGxEtext & $MeetGorEtext & $MeetGplusEtext & $MeetDEtext & $MeetTrophytext & $MeetTHtext & $MeetTHOtext & $MeetWeakBasetext & $EnabledAftertext)

			If $iChkMeetOne[$x] = 1 And Not ($Is_SearchLimit) Then SetLog("Meet One and Attack!")

			If Not ($Is_SearchLimit) Then SetLog(_PadStringCenter(" RESOURCE CONDITIONS ", 50, "~"), $COLOR_BLUE)
			If $iChkMeetTH[$x] = 1 Then $iAimTHtext[$x] = " [TH]:" & StringFormat("%2s", $iMaxTH[$x]) ;$icmbTH
			If $iChkMeetTHO[$x] = 1 Then $iAimTHtext[$x] &= ", Out"

			If $iCmbMeetGE[$x] = 2 Then
				If Not ($Is_SearchLimit) Then SetLog("Aim: [G+E]:" & StringFormat("%7s", $iAimGoldPlusElixir[$x]) & " [D]:" & StringFormat("%5s", $iAimDark[$x]) & " [T]:" & StringFormat("%2s", $iAimTrophy[$x]) & $iAimTHtext[$x] & " for: " & $sModeText[$x], $COLOR_GREEN, "Lucida Console", 7.5)
			Else
				If Not ($Is_SearchLimit) Then SetLog("Aim: [G]:" & StringFormat("%7s", $iAimGold[$x]) & " [E]:" & StringFormat("%7s", $iAimElixir[$x]) & " [D]:" & StringFormat("%5s", $iAimDark[$x]) & " [T]:" & StringFormat("%2s", $iAimTrophy[$x]) & $iAimTHtext[$x] & " for: " & $sModeText[$x], $COLOR_GREEN, "Lucida Console", 7.5)
			EndIf
		EndIf
	Next

	If $OptBullyMode + $OptTrophyMode + $chkATH > 0 Then
		If Not ($Is_SearchLimit) Then SetLog(_PadStringCenter(" ADVANCED SETTINGS ", 50, "~"), $COLOR_BLUE)
		Local $YourTHText = "", $chkATHText = "", $OptTrophyModeText = ""

		If $OptBullyMode = 1 Then
			For $i = 0 To 4
				If $YourTH = $i Then $YourTHText = "TH" & $THText[$i]
			Next
		EndIf

		If $OptBullyMode = 1 And Not ($Is_SearchLimit) Then SetLog("THBully Combo @" & $ATBullyMode & " SearchCount, " & $YourTHText)

		If $chkATH = 1 Then $chkATHText = " Attack TH Outside "
		If $OptTrophyMode = 1 Then $OptTrophyModeText = "THSnipe Combo, " & $THaddtiles & " Tile(s), "
		If ($OptTrophyMode = 1 Or $chkATH = 1) And Not ($Is_SearchLimit) Then SetLog($OptTrophyModeText & $chkATHText & $txtAttackTHType)
		SetLog("Aim: [G]:" & StringFormat("%7s", $iMinGold[$TS]) & " [E]:" & StringFormat("%7s", $iMinElixir[$TS]) & " [D]:" & StringFormat("%5s", $iMinDark[$TS]), $COLOR_GREEN, "Lucida Console", 7.5)
	EndIf

	If Not ($Is_SearchLimit) Then
		SetLog(_StringRepeat("=", 50), $COLOR_BLUE)
	Else
		SetLog(_PadStringCenter(" Restart To Search ", 54, "="), $COLOR_BLUE)
	EndIf

	If $iChkAttackNow = 1 Then
		GUICtrlSetState($btnAttackNowDB, $GUI_SHOW)
		GUICtrlSetState($btnAttackNowLB, $GUI_SHOW)
		GUICtrlSetState($btnAttackNowTS, $GUI_SHOW)
		GUICtrlSetState($pic2arrow, $GUI_HIDE)
		GUICtrlSetState($lblVersion, $GUI_HIDE)
	EndIf

	If $Is_ClientSyncError = False And $Is_SearchLimit = False Then
		$SearchCount = 0
	EndIf

	If $Is_SearchLimit = True Then $Is_SearchLimit = False

	While 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;### Main Search Loop ###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		If $debugVillageSearchImages = 1 Then DebugImageSave("villagesearch")
		$logwrited = False
		$bBtnAttackNowPressed = False
		If $iVSDelay > 0 And $iMaxVSDelay > 0 Then ; Check if village delay values are set
			If $iVSDelay <> $iMaxVSDelay Then ; Check if random delay requested
				If _Sleep(Round(1000 * Random($iVSDelay, $iMaxVSDelay))) Then Return ;Delay time is random between min & max set by user
			Else
				If _Sleep(1000 * $iVSDelay) Then Return ; Wait Village Serch delay set by user
			EndIf
		EndIf

		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC

		If $Restart = True Then Return ; exit func
		GetResources(False) ; Reads Resource Values
		If $Restart = True Then Return ; exit func

		If Mod(($iSkipped + 1), 100) = 0 Then
			_WinAPI_EmptyWorkingSet(WinGetProcess($Title)) ; reduce BS memory
			If _Sleep($iDelayRespond) Then Return
			If CheckZoomOut() = False Then Return
		EndIf

		; check DE/drill for Zap
		$numDEDrill = 0
		$DEperDrill = 0
		Switch $iTownHallLevel
			Case 10, 11
				$numDEDrill = 3
			Case 8, 9 
				$numDEDrill = 2
			Case 7
				$numDEDrill = 1
		EndSwitch
		If $numDEDrill = 0 Then
			$DEperDrill = (Number($searchDark) / $numDEDrill)
		EndIf
		
		$isDeadBase = False
		$zapBaseMatch = $ichkDBLightSpell = 1 And $CurLightningSpell > 0 And $DEperDrill >= Number($itxtDBLightMinDark)
		Local $noMatchTxt = ""
		Local $match[$iModeCount]
		Local $isModeActive[$iModeCount]
		For $i = 0 To $iModeCount - 1
			$match[$i] = False
			$isModeActive[$i] = False
		Next

		If _Sleep($iDelayRespond) Then Return
		If $iCmbSearchMode = 0 Then
			$isModeActive[$DB] = True
			$match[$DB] = CompareResources($DB)
		ElseIf $iCmbSearchMode = 1 Then
			$isModeActive[$LB] = True
			$match[$LB] = CompareResources($LB)
		ElseIf $iCmbSearchMode = 2 Then
			For $i = 0 To $iModeCount - 2
				$isModeActive[$i] = IsSearchModeActive($i)
				If $isModeActive[$i] Then
					$match[$i] = CompareResources($i)
				EndIf
			Next
		EndIf
		If IsSearchModeActive($TS) Then $match[$TS] = CompareResources($TS)

		If _Sleep($iDelayRespond) Then Return
		For $i = 0 To $iModeCount - 2
			If ($match[$i] And $iChkWeakBase[$i] = 1 And $iChkMeetOne[$i] <> 1) Or ($isModeActive[$i] And Not $match[$i] And $iChkWeakBase[$i] = 1 And $iChkMeetOne[$i] = 1) Then
				If IsWeakBase($i) Then
					$match[$i] = True
				Else
					$match[$i] = False
					$noMatchTxt &= ", Not a Weak Base for " & $sModeText[$i]
				EndIf
			EndIf
		Next

		If _Sleep($iDelayRespond) Then Return
		If $match[$DB] Or $match[$LB] Or $match[$TS] Or $zapBaseMatch Then
			$isDeadBase = checkDeadBase()
		EndIf
		$zapBaseMatch = $zapBaseMatch And $isDeadBase
		; snipe dead base only if have enough troops to use for greedy attack
		If $isDeadBase Then $match[$TS] = $match[$TS] And ($CurCamp > $iMinTroopToAttackDB)

		If _Sleep($iDelayRespond) Then Return
		If $match[$DB] And $isDeadBase Then
			SetLog($GetResourcesTXT, $COLOR_GREEN, "Lucida Console", 7.5)
			SetLog("      Dead Base Found!", $COLOR_GREEN, "Lucida Console", 7.5)
			$logwrited = True
			; check for outside collectors if enabled
			If $ichkDBMeetCollOutside = 1 Then
				If AreCollectorsOutside($iDBMinCollOutsidePercent) Then
					SetLog("Collectors are outside.", $COLOR_GREEN, "Lucida Console", 7.5)
					$iMatchMode = $DB
					If $debugDeadBaseImage = 1 Then
						_CaptureRegion()
						_GDIPlus_ImageSaveToFile($hBitmap, @ScriptDir & "\Zombies\" & $Date & " at " & $Time & ".png")
						_WinAPI_DeleteObject($hBitmap)
					EndIf
					ExitLoop
				Else
					SetLog("Collectors are not outside!", $COLOR_RED, "Lucida Console", 7.5)
					If $zapBaseMatch Then ; collectors not outside but drills can still be zapped
						SetLog("      Drills can be zapped!", $COLOR_GREEN, "Lucida Console")	
						$logwrited = True
						If DEDropSmartSpell() = True Then
							ReturnHome($TakeLootSnapShot)
							$ReStart = True  ; Set restart flag after DE zap to return from AttackMain()
							Return
						Else ; select first troop type for drop trophy
							SelectDropTroop(0)
						EndIf
					EndIf
				EndIf
			Else
				$iMatchMode = $DB
				If $debugDeadBaseImage = 1 Then
					_CaptureRegion()
					_GDIPlus_ImageSaveToFile($hBitmap, @ScriptDir & "\Zombies\" & $Date & " at " & $Time & ".png")
					_WinAPI_DeleteObject($hBitmap)
				EndIf
				ExitLoop
			EndIf
		ElseIf $match[$LB] And Not $isDeadBase Then
			SetLog($GetResourcesTXT, $COLOR_GREEN, "Lucida Console", 7.5)
			SetLog("      Live Base Found!", $COLOR_GREEN, "Lucida Console", 7.5)
			$logwrited = True
			$iMatchMode = $LB
			ExitLoop
		ElseIf $match[$LB] Or $match[$DB] Then
			If $OptBullyMode = 1 And ($SearchCount >= $ATBullyMode) Then
				If $SearchTHLResult = 1 Then
					SetLog($GetResourcesTXT, $COLOR_GREEN, "Lucida Console", 7.5)
					SetLog("      Not a match, but TH Bully Level Found! ", $COLOR_GREEN, "Lucida Console", 7.5)
					$logwrited = True
					$iMatchMode = $iTHBullyAttackMode
					ExitLoop
				EndIf
			EndIf
		EndIf

		If _Sleep($iDelayRespond) Then Return
		If $OptTrophyMode = 1 Then ; Enables Combo Mode Settings
			If $match[$TS] And SearchTownHallLoc() Then ; attack this if outside TH found and requirements are met for snipe
				If $ichkTSSkipTrappedTH = 1 Then
					If IsTHTrapped() Then
						$noMatchTxt &= ", TH is trapped, skip snipe"
					Else
						THSnipeFound()
						ExitLoop
					EndIf
				Else						
					THSnipeFound()
					ExitLoop
				EndIf
			EndIf
		EndIf
		
		; DE drill Zap if it's a match
		If $zapBaseMatch Then
			SetLog($GetResourcesTXT, $COLOR_GREEN, "Lucida Console", 7.5)
			SetLog("      Dead Base found for DE zap!", $COLOR_GREEN, "Lucida Console")	
			$logwrited = True
			$isDeadBase = True
			If DEDropSmartSpell() = True Then
				ReturnHome($TakeLootSnapShot)
				$ReStart = True  ; Set restart flag after DE zap to return from AttackMain()
				Return
			Else ; select first troop type for drop trophy
				SelectDropTroop(0)
			EndIf
		EndIf

		If _Sleep($iDelayRespond) Then Return
		If $match[$DB] And Not $isDeadBase Then
			$noMatchTxt &= ", Not a " & $sModeText[$DB]
			If $debugDeadBaseImage = 1 Then
				_CaptureRegion()
				_GDIPlus_ImageSaveToFile($hBitmap, @ScriptDir & "\SkippedZombies\" & $Date & " at " & $Time & ".png")
				_WinAPI_DeleteObject($hBitmap)
			EndIf
		ElseIf $match[$LB] And $isDeadBase Then
			$noMatchTxt &= ", Not a " & $sModeText[$LB]
		EndIf

		If $noMatchTxt <> "" Then
			SetLog($GetResourcesTXT, $COLOR_BLACK, "Lucida Console", 7.5)
			SetLog("      " & StringMid($noMatchTxt, 3), $COLOR_BLACK, "Lucida Console", 7.5)
			$logwrited = True
		EndIf

		If $iChkAttackNow = 1 Then
			If _Sleep(1000 * $iAttackNowDelay) Then Return ; add human reaction time on AttackNow button function
		EndIf

		If Not ($logwrited) Then
			SetLog($GetResourcesTXT, $COLOR_BLACK, "Lucida Console", 7.5)
		EndIf

		If $bBtnAttackNowPressed = True Then ExitLoop

		; th snipe stop condition
		If SWHTSearchLimit($iSkipped + 1) Then Return True
		; Return Home on Search limit
		If SearchLimit($iSkipped + 1) Then Return True

		Local $i = 0
		While $i < 100
			If _Sleep($iDelayVillageSearch2) Then Return
			$i += 1
			If ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) And IsAttackPage() Then
				ClickP($NextBtn, 1, 0, "#0155") ; Click Next
				ExitLoop
			Else
				$Result = getAttackDisable(346, 182) ; Grab Ocr for TakeABreak check
				checkAttackDisable($iTaBChkAttack, $Result) ; check to see If TakeABreak msg on screen after next click
				If $Restart = True Then Return ; exit func
				If $debugsetlog = 1 Then SetLog("Wait to see Next Button... " & $i, $COLOR_PURPLE)
			EndIf
			If $i >= 99 Or isProblemAffect(True) Then ; if we can't find the next button or there is an error, then restart
				$Is_ClientSyncError = True
				checkMainScreen()
				If $Restart Then
					$iNbrOfOoS += 1
					UpdateStats()
					SetLog("Couldn't locate Next button", $COLOR_RED)
					PushMsg("OoSResources")
				Else
					SetLog("Have strange problem Couldn't locate Next button, Restarting CoC and Bot...", $COLOR_RED)
					$Is_ClientSyncError = False ; disable fast OOS restart if not simple error and try restarting CoC
					CloseCoC(True)
				EndIf
				Return
			EndIf
		WEnd

		If _Sleep($iDelayRespond) Then Return
		$Result = getAttackDisable(346, 182) ; Grab Ocr for TakeABreak check
		checkAttackDisable($iTaBChkAttack, $Result) ; check to see If TakeABreak msg on screen after next click
		If $Restart = True Then Return ; exit func

		If isGemOpen(True) = True Then
			Setlog(" Not enough gold to keep searching.....", $COLOR_RED)
			Click(585, 252, 1, 0, "#0156") ; Click close gem window "X"
			If _Sleep($iDelayVillageSearch3) Then Return
			$OutOfGold = 1 ; Set flag for out of gold to search for attack
			ReturnHome(False, False)
			Return
		EndIf

		$iSkipped = $iSkipped + 1
		$iSkippedVillageCount += 1
		If $iTownHallLevel <> "" Then
			$iSearchCost += $aSearchCost[$iTownHallLevel - 1]
			$iGoldTotal -= $aSearchCost[$iTownHallLevel - 1]
		EndIf
		UpdateStats()
	WEnd ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;### Main Search Loop End ###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	If $bBtnAttackNowPressed = True Then
		Setlog(_PadStringCenter(" Attack Now Pressed! ", 50, "~"), $COLOR_GREEN)
	EndIf

	If $iChkAttackNow = 1 Then
		GUICtrlSetState($btnAttackNowDB, $GUI_HIDE)
		GUICtrlSetState($btnAttackNowLB, $GUI_HIDE)
		GUICtrlSetState($btnAttackNowTS, $GUI_HIDE)
		GUICtrlSetState($pic2arrow, $GUI_SHOW)
		GUICtrlSetState($lblVersion, $GUI_SHOW)
		$bBtnAttackNowPressed = False
	EndIf

	If $AlertSearch = 1 Then
		TrayTip($sModeText[$iMatchMode] & " Match Found!", "Gold: " & $searchGold & "; Elixir: " & $searchElixir & "; Dark: " & $searchDark & "; Trophy: " & $searchTrophy, "", 0)
		If FileExists(@WindowsDir & "\media\Festival\Windows Exclamation.wav") Then
			SoundPlay(@WindowsDir & "\media\Festival\Windows Exclamation.wav", 1)
		ElseIf FileExists(@WindowsDir & "\media\Windows Exclamation.wav") Then
			SoundPlay(@WindowsDir & "\media\Windows Exclamation.wav", 1)
		EndIf
	EndIf

	SetLog(_PadStringCenter(" Search Complete ", 50, "="), $COLOR_BLUE)
	PushMsg("MatchFound")

	; TH Detection Check Once Conditions
	If $OptBullyMode = 0 And $OptTrophyMode = 0 And $iChkMeetTH[$iMatchMode] = 0 And $iChkMeetTHO[$iMatchMode] = 0 And $chkATH = 1 Then
		$searchTH = checkTownHallADV2()

		If SearchTownHallLoc() = False And $searchTH <> "-" Then
			SetLog("Checking Townhall location: TH is inside, skip Attack TH")
		ElseIf $searchTH <> "-" Then
			SetLog("Checking Townhall location: TH is outside, Attacking Townhall!")
		Else
			SetLog("Checking Townhall location: Could not locate TH, skipping attack TH...")
		EndIf
	EndIf

	$Is_ClientSyncError = False
EndFunc   ;==>VillageSearch

Func IsSearchModeActive($pMode)
	If $iChkEnableAfter[$pMode] = 0 Then Return True
	If $SearchCount = $iEnableAfterCount[$pMode] Then SetLog(_PadStringCenter(" " & $sModeText[$pMode] & " search conditions are activated! ", 50, "~"), $COLOR_BLUE)
	If $SearchCount >= $iEnableAfterCount[$pMode] Then Return True
	Return False
EndFunc   ;==>IsSearchModeActive

Func IsWeakBase($pMode)
	_WinAPI_DeleteObject($hBitmapFirst)
	$hBitmapFirst = _CaptureRegion2()
	Local $resultHere = DllCall($hFuncLib, "str", "CheckConditionForWeakBase", "ptr", $hBitmapFirst, "int", ($iCmbWeakMortar[$pMode] + 1), "int", ($iCmbWeakWizTower[$pMode] + 1), "int", 10)
	If @error Then ; detect if DLL error and return weakbase not found
		SetLog("Weakbase search DLL error", $COLOR_RED)
		Return False
	EndIf
	If $debugsetlog = 1 Then Setlog("Weakbase result= " & $resultHere[0], $COLOR_PURPLE) ;debug
	If $resultHere[0] = "Y" Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>IsWeakBase

Func AreCollectorsOutside($percent) ; dark drills are ignored since they can be zapped
	SetLog("Locating Mines & Collectors", $COLOR_BLUE)	
	; reset variables
	Global $PixelMine[0]
	Global $PixelElixir[0]
	Global $PixelNearCollector[0]
	Local $colOutside = 0
	Local $hTimer = TimerInit()
	_WinAPI_DeleteObject($hBitmapFirst)
	$hBitmapFirst = _CaptureRegion2()
	
	$PixelMine = GetLocationMine()
	If (IsArray($PixelMine)) Then
		_ArrayAdd($PixelNearCollector, $PixelMine)
	EndIf
	$PixelElixir = GetLocationElixir()
	If (IsArray($PixelElixir)) Then
		_ArrayAdd($PixelNearCollector, $PixelElixir)
	EndIf
	Local $colNbr = UBound($PixelNearCollector)
	SetLog("Located collectors in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds:")
	SetLog("[" & UBound($PixelMine) & "] Gold Mines")
	SetLog("[" & UBound($PixelElixir) & "] Elixir Collectors")
	$iNbrOfDetectedMines[$DB] += UBound($PixelMine)
	$iNbrOfDetectedCollectors[$DB] += UBound($PixelElixir)
	UpdateStats()
	
	Local $minColOutside = Round($colNbr * $percent / 100)
	Local $radiusAdjustment = 1
	If $searchTH <> "-" Then
		$radiusAdjustment *= Number($searchTH) / 10
	EndIf
	
	For $i = 0 To $colNbr - 1
		Local $arrPixel = $PixelNearCollector[$i]
		If UBound($arrPixel) > 0 Then
			If isOutsideEllipse($arrPixel[0], $arrPixel[1], $CollectorsEllipseWidth * $radiusAdjustment, $CollectorsEllipseHeigth * $radiusAdjustment) Then 
				If $debugsetlog = 1 Then SetLog("Collector (" & $arrPixel[0] & ", " & $arrPixel[1] & ") is outside", $COLOR_PURPLE)
				$colOutside += 1
			EndIf
		EndIf
		If $colOutside >= $minColOutside Then 
			If $debugsetlog = 1 Then SetLog("More than " & $percent & "% of the collectors are outside", $COLOR_PURPLE)
			Return True
		EndIf
	Next
	If $debugsetlog = 1 Then SetLog($colOutside & " collectors found outside (out of " & $colNbr & ")", $COLOR_PURPLE)
	Return False
EndFunc   ;==>AreCollectorsOutside

Func THSnipeFound()
	SetLog($GetResourcesTXT, $COLOR_GREEN, "Lucida Console", 7.5)
	SetLog("      TH outside found & enough resources for snipe", $COLOR_GREEN, "Lucida Console", 7.5)	
	$logwrited = True
	$iMatchMode = $TS	
EndFunc

Func SearchLimit($iSkipped)
	If $iChkRestartSearchLimit = 1 And $iSkipped >= Number($iRestartSearchlimit) Then
		Local $Wcount = 0
		While _CheckPixel($aSurrenderButton, $bCapturePixel) = False
			If _Sleep($iDelaySWHTSearchLimit1) Then Return
			$Wcount += 1
			If $debugsetlog = 1 Then SetLog("Wait for surrender button " & $Wcount, $COLOR_PURPLE)
			If $Wcount >= 50 Or isProblemAffect(True) Then
				checkMainScreen()
				$Is_ClientSyncError = False ; reset OOS flag for long restart
				$Restart = True ; set force runbot restart flag
				Return True
			EndIf
		WEnd
		ReturnHome(False, False) ;If End battle is available
		$Restart = True ; set force runbot restart flag
		$Is_ClientSyncError = True ; set OOS flag for fast restart
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>SearchLimit