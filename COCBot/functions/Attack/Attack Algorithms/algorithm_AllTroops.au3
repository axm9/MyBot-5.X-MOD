; #FUNCTION# ====================================================================================================================
; Name ..........: algorith_AllTroops
; Description ...: This file contens all functions to attack algorithm will all Troops , using Barbarians, Archers, Goblins, Giants and Wallbreakers as they are available
; Syntax ........: algorithm_AllTroops()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: Didipe (May-2015), ProMac(2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func algorithm_AllTroops() ; Attack Algorithm for all existing troops
	If $debugSetlog = 1 Then Setlog("algorithm_AllTroops", $COLOR_PURPLE)
	SetSlotSpecialTroops()

	If _Sleep($iDelayalgorithm_AllTroops1) Then Return
	
	If $iMatchMode = $TS Then ; TH snipe if TH is outside
		SwitchAttackTHType()
		If $zoomedin = True Then
			ZoomOut()
			$zoomedin = False
			$zCount = 0
			$sCount = 0
		EndIf
	EndIf

	If $iMatchMode = $TS Then Return ; Exit attacking if greedy mode didn't detect dead base		

	If ($iChkRedArea[$iMatchMode]) Then
		SetLog("Calculating Smart Attack Strategy", $COLOR_BLUE)
		Local $hTimer = TimerInit()
		_WinAPI_DeleteObject($hBitmapFirst)
		$hBitmapFirst = _CaptureRegion2()
		_GetRedArea()

		If ($iChkSmartAttack[$iMatchMode][0] = 1 Or $iChkSmartAttack[$iMatchMode][1] = 1 Or $iChkSmartAttack[$iMatchMode][2] = 1) Then
			Global $PixelNearCollector[0]
			$hTimer = TimerInit()
				
			; check collectors and mines only if it was not done during collector outside detection
			If $ichkDBMeetCollOutside = 0 And $iChkSmartAttack[$iMatchMode][0] = 1 Then
				Global $PixelMine[0]
				$PixelMine = GetLocationMine()
				If (IsArray($PixelMine)) Then
					_ArrayAdd($PixelNearCollector, $PixelMine)
					$iNbrOfDetectedMines[$iMatchMode] += UBound($PixelMine)
					SetLog("Found [" & UBound($PixelMine) & "] Gold Mines")
				EndIf
			EndIf
			If $ichkDBMeetCollOutside = 0 And $iChkSmartAttack[$iMatchMode][1] = 1 Then
				Global $PixelElixir[0]
				$PixelElixir = GetLocationElixir()
				If (IsArray($PixelElixir)) Then
					_ArrayAdd($PixelNearCollector, $PixelElixir)
					$iNbrOfDetectedCollectors[$iMatchMode] += UBound($PixelElixir)
					SetLog("Found [" & UBound($PixelElixir) & "] Elixir Collectors")
				EndIf
			EndIf
			If $iChkSmartAttack[$iMatchMode][2] = 1 Then					
				Global $PixelDarkElixir[0]
				$PixelDarkElixir = GetLocationDarkElixir()
				If (IsArray($PixelDarkElixir)) Then
					_ArrayAdd($PixelNearCollector, $PixelDarkElixir)
					$iNbrOfDetectedDrills[$iMatchMode] += UBound($PixelDarkElixir)
					SetLog("Found [" & UBound($PixelDarkElixir) & "] Dark Elixir Drills")
				EndIf
			EndIf
			UpdateStats()
		EndIf
		SetLog("Calculated (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)")
	EndIf

	;########################################################################################################################
	Local $nbSides = 0
	Switch $iChkDeploySettings[$iMatchMode]
		Case 0 ; Single sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on a single side", $COLOR_BLUE)
			$nbSides = 1
		Case 1 ; Two sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on two sides", $COLOR_BLUE)
			$nbSides = 2
		Case 2 ; Three sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on three sides", $COLOR_BLUE)
			$nbSides = 3
		Case 3 ; All sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on all sides", $COLOR_BLUE)
			$nbSides = 4
		Case 4 ; FF ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking with Four Finger style", $COLOR_BLUE)
			$nbSides = 5
		Case 5 ; DE Side - Live Base only ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on Dark Elixir Side.", $COLOR_BLUE)
			$nbSides = 1
			If Not ($iChkRedArea[$iMatchMode]) Then GetBuildingEdge($eSideBuildingDES) ; Get DE Storage side when Redline is not used.
		Case 6 ; TH Side - Live Base only ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on Town Hall Side.", $COLOR_BLUE)
			$nbSides = 1
			If Not ($iChkRedArea[$iMatchMode]) Then GetBuildingEdge($eSideBuildingTH) ; Get Townhall side when Redline is not used.
	EndSwitch
	If ($nbSides = 0) Then Return
	If _Sleep($iDelayalgorithm_AllTroops2) Then Return

	; $ListInfoDeploy = [Troop, No. of Sides, $WaveNb, $MaxWaveNb, $slotsPerEdge]
	If $iMatchMode = $LB And $iChkDeploySettings[$LB] = 5 Then ; Customise DE side wave deployment here
		Local $listInfoDeploy[13][5] = [[$eGiant, $nbSides, 1, 1, 2] _
			, [$eWall, $nbSides, 1, 1, 2] _
			, [$eBarb, $nbSides, 1, 2, 2] _
			, [$eArch, $nbSides, 1, 3, 3] _
			, [$eBarb, $nbSides, 2, 2, 2] _
			, [$eArch, $nbSides, 2, 3, 3] _
			, ["CC", 1, 1, 1, 1] _
			, ["HEROES", 1, 2, 1, 0] _
			, [$eHogs, $nbSides, 1, 1, 1] _
			, [$eWiza, $nbSides, 1, 1, 0] _
			, [$eMini, $nbSides, 1, 1, 0] _
			, [$eArch, $nbSides, 3, 3, 2] _
			, [$eGobl, $nbSides, 1, 1, 1] _
			]
	ElseIf $nbSides = 5 Then
		If $debugSetlog = 1 Then SetLog("listdeploy fourfinger for attack", $COLOR_PURPLE)
		Local $listInfoDeploy[11][5] = [[$eGiant, $nbSides, 1, 1, 2] _
			, [$eBarb, $nbSides, 1, 1, 0] _
			, [$eWall, $nbSides, 1, 1, 1] _
			, [$eArch, $nbSides, 1, 1, 0] _
			, [$eGobl, $nbSides, 1, 2, 0] _
			, ["CC", 1, 1, 1, 1] _
			, [$eHogs, $nbSides, 1, 1, 1] _
			, [$eWiza, $nbSides, 1, 1, 0] _
			, [$eMini, $nbSides, 1, 1, 0] _
			, [$eGobl, $nbSides, 2, 2, 0] _
			, ["HEROES", 1, 2, 1, 1] _
			]
	Else
		If $debugSetlog = 1 Then SetLog("listdeploy standard for attack", $COLOR_PURPLE)
		Local $listInfoDeploy[11][5] = [[$eGiant, $nbSides, 1, 1, 2] _
			, [$eBarb, $nbSides, 1, 1, 0] _
			, [$eWall, $nbSides, 1, 1, 1] _
			, [$eArch, $nbSides, 1, 2, 0] _
			, [$eGobl, $nbSides, 1, 1, 0] _
			, ["CC", 1, 1, 1, 1] _
			, [$eHogs, $nbSides, 1, 1, 1] _
			, [$eWiza, $nbSides, 1, 1, 0] _
			, [$eMini, $nbSides, 1, 1, 0] _
			, [$eArch, $nbSides, 2, 2, 0] _
			, ["HEROES", 1, 2, 1, 1] _
			]
	EndIf

	$isCCDropped = False
	$DeployCCPosition[0] = -1
	$DeployCCPosition[1] = -1
	$isHeroesDropped = False
	$DeployHeroesPosition[0] = -1
	$DeployHeroesPosition[1] = -1

	LaunchTroop2($listInfoDeploy, $CC, $King, $Queen, $Warden)

	If _Sleep($iDelayalgorithm_AllTroops4) Then Return
	SetLog("Dropping left over troops", $COLOR_BLUE)
	PrepareAttack($iMatchMode, True) ; Check remaining quantities
	For $i = $eBarb To $eLava ; lauch all remaining troops
		LauchTroop($i, $nbSides, 0, 1)
		CheckHeroesHealth()
		If _Sleep($iDelayalgorithm_AllTroops5) Then Return
	Next

	; Activate KQ's power
	If ($checkKPower Or $checkQPower) And $iActivateKQCondition = "Manual" Then
		SetLog("Waiting " & $delayActivateKQ / 1000 & " seconds before activating Hero abilities", $COLOR_BLUE)
		If _Sleep($delayActivateKQ) Then Return
		If $checkKPower Then
			SetLog("Activating King's power", $COLOR_BLUE)
			SelectDropTroop($King)
			$checkKPower = False
		EndIf
		If $checkQPower Then
			SetLog("Activating Queen's power", $COLOR_BLUE)
			SelectDropTroop($Queen)
			$checkQPower = False
		EndIf
	EndIf

	SetLog("Finished Attacking, waiting for the battle to end")
EndFunc   ;==>algorithm_AllTroops

Func SetSlotSpecialTroops()
	$King = -1
	$Queen = -1
	$CC = -1
	$Warden = -1
	For $i = 0 To UBound($atkTroops) - 1
		If $atkTroops[$i][0] = $eCastle Then
			$CC = $i
		ElseIf $atkTroops[$i][0] = $eKing Then
			$King = $i
		ElseIf $atkTroops[$i][0] = $eQueen Then
			$Queen = $i
		ElseIf $atkTroops[$i][0] = $eWarden Then
			$Warden = $i
		EndIf
	Next
	If $debugSetlog=1 Then SetLog("Use king  SLOT n° " & $King, $COLOR_PURPLE)
	If $debugSetlog=1 Then SetLog("Use queen SLOT n° " & $Queen, $COLOR_PURPLE)
	If $debugSetlog=1 Then SetLog("Use CC SLOT n° " & $CC, $COLOR_PURPLE)
	If $debugSetlog=1 Then SetLog("Use Warden SLOT n° " & $Warden, $COLOR_PURPLE)
EndFunc

Func CloseBattle()
	For $i = 1 To 30
		If _ColorCheck(_GetPixelColor($aWonOneStar[0], $aWonOneStar[1], True), Hex($aWonOneStar[2], 6), $aWonOneStar[3]) = True Then ExitLoop ;exit if not 'no star'
		If _Sleep($iDelayalgorithm_AllTroops2) Then Return
	Next

	If IsAttackPage() Then ClickP($aSurrenderButton, 1, 0, "#0030") ;Click Surrender
	If _Sleep($iDelayalgorithm_AllTroops3) Then Return
	If IsEndBattlePage() Then
		ClickP($aConfirmSurrender, 1, 0, "#0031") ;Click Confirm
		If _Sleep($iDelayalgorithm_AllTroops1) Then Return
	EndIf
EndFunc   ;==>CloseBattle