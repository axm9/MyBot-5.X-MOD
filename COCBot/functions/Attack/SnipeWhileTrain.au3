; #FUNCTION# ====================================================================================================================
; Name ..........: SnipeWhileTrain
; Description ...: During the idle loop, if $chkSnipeWhileTrain is checked, the bot will go to pure TH snipe
;                  and return after limit searches to profit from idle time.
; Syntax ........:
; Parameters ....: None
; Return values .: False if not enough troops ($iminArmyCapacityTHSnipe%) True if Limit searches was successfully done.
; Author ........: ChiefM3
; Modified ......: The Master, Sardo (2015-10)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SnipeWhileTrain()
	If $DebugSetLog = 1 Then Setlog("Snipe While Train", $COLOR_PURPLE)
	If $iChkSnipeWhileTrain = 1 And $CommandStop <> 0 And $CommandStop <> 3 Then
		; Attempt only when $iminArmyCapacityTHSnipe % army full to prevent failure of TH snipe
		If ($CurCamp <= ($TotalCamp * $itxtminArmyCapacityTHSnipe / 100)) Then
			SetLog("Army Capacity below " & $itxtminArmyCapacityTHSnipe & "%, not enough for Snipe While Train")
			Return False
		EndIf

		If $fullArmy = False And ($CurCamp /$TotalCamp >=  ($itxtminArmyCapacityTHSnipe / 100) )  = True Then
			; Swap variables to pure TH snipe mode
			$tempSnipeWhileTrain[0] = $iChkMeetTrophy[$DB]
			$tempSnipeWhileTrain[1] = $iChkMeetTrophy[$LB]
			$tempSnipeWhileTrain[2] = $iMinTrophy[$DB]
			$tempSnipeWhileTrain[3] = $iMinTrophy[$LB]
			$tempSnipeWhileTrain[4] = $iChkMeetOne[$LB]
			$tempSnipeWhileTrain[5] = $iChkMeetOne[$DB]
			$tempSnipeWhileTrain[6] = $OptTrophyMode
			$tempSnipeWhileTrain[7] = $iChkDeploySettings[$DB]
			$tempSnipeWhileTrain[8] = $iChkRedArea[$DB]
			$tempSnipeWhileTrain[9] = $iChkSmartAttack[$DB][0] 
			$tempSnipeWhileTrain[10] = $iChkSmartAttack[$DB][1]
			$tempSnipeWhileTrain[11] = $iChkSmartAttack[$DB][2]
			$tempSnipeWhileTrain[12] = $ichkDBMeetCollOutside
			$tempSnipeWhileTrain[13] = $iDBMinCollOutsidePercent
			
			; this will disable normal attacks in SWT mode
			$iChkMeetTrophy[$DB] = 1
			$iChkMeetTrophy[$LB] = 1
			$iMinTrophy[$DB] = 99
			$iMinTrophy[$LB] = 99
			$iChkMeetOne[$DB] = 0
			$iChkMeetOne[$LB] = 0
			$OptTrophyMode = 1
				
			; if greedy mode enabled
			If $ichkAttackIfDB = 1 Then	
				Setlog("Min collector outside set to 70% during snipe while train mode", $COLOR_PURPLE)
				; bot should only attack dead bases with 70% of collectors outside in SWT mode
				$ichkDBMeetCollOutside = 1
				$iDBMinCollOutsidePercent = 70
				
				If $iChkSWTSmartAttack = 1 Then
					Setlog("Smart Attack near collectors during snipe while train mode", $COLOR_PURPLE)
					; smart attack dropping near collectors
					$iChkDeploySettings[$DB] = 3
					$iChkRedArea[$DB] = 1
					$iChkSmartAttack[$DB][0] = 1
					$iChkSmartAttack[$DB][1] = 1
					$iChkSmartAttack[$DB][2] = 1
				EndIf
			EndIf

			; used to Change back values
			$SnipeChangedSettings = True

			; go to search for Search Limit times
			SetLog("***[Trying TH snipe while training army]***", 0x808000)
			$isSnipeWhileTrain = True
			$Is_ClientSyncError = False
			AttackMain()
			$Restart = False ; Sets $Restart as True to end search after Limit Search is over so this return it to false so that the bot dont restart
			$Is_ClientSyncError = False
			$isSnipeWhileTrain = False
			SetLog("***[End trying TH snipe while training army]***", 0x808000)

			SWHTrainRevertNormal()

			Return True
		EndIf
	EndIf
EndFunc   ;==>SnipeWhileTrain

Func SWHTrainRevertNormal()
	If $SnipeChangedSettings = True Then
		; Change settings back to Original
		$iChkMeetTrophy[$DB] = $tempSnipeWhileTrain[0]
		$iChkMeetTrophy[$LB] = $tempSnipeWhileTrain[1]
		$iMinTrophy[$DB] = $tempSnipeWhileTrain[2]
		$iMinTrophy[$LB] = $tempSnipeWhileTrain[3]
		$iChkMeetOne[$LB] = $tempSnipeWhileTrain[4]
		$iChkMeetOne[$DB] = $tempSnipeWhileTrain[5]
		$OptTrophyMode = $tempSnipeWhileTrain[6]
		$iChkDeploySettings[$DB] = $tempSnipeWhileTrain[7]
		$iChkRedArea[$DB] = $tempSnipeWhileTrain[8]
		$iChkSmartAttack[$DB][0] = $tempSnipeWhileTrain[9]
		$iChkSmartAttack[$DB][1] = $tempSnipeWhileTrain[10]
		$iChkSmartAttack[$DB][2] = $tempSnipeWhileTrain[11]
		$ichkDBMeetCollOutside = $tempSnipeWhileTrain[12]
		$iDBMinCollOutsidePercent = $tempSnipeWhileTrain[13]
		$Is_ClientSyncError = False
	EndIf
	$SnipeChangedSettings = False
	$isSnipeWhileTrain = False
EndFunc   ;==>SWHTrainRevertNormal

Func SWHTSearchLimit($iSkipped)
	If $isSnipeWhileTrain And $iSkipped >= Number($itxtSearchlimit) Then
		Local $Wcount = 0
		While not(_CheckPixel($aSurrenderButton, $bCapturepixel))
			If _Sleep($iDelaySWHTSearchLimit1) Then Return
			$Wcount += 1
			If $debugSetlog = 1 Then Setlog("Wait for surrender button " & $Wcount, $COLOR_PURPLE)
			If $Wcount >= 50 Then ExitLoop
		WEnd

		If IsAttackPage() Then ClickP($aSurrenderButton, 1, 0, "#9999")

		$Restart = True ; To Prevent Initiation of Attack

		Local $mCount
		$mCcount = 0
		While Not (_CheckPixel($aIsMain, $bCapturepixel))
			If _Sleep($iDelaySearchLimit2) Then Return
			$mCcount += 1
			If $debugSetlog = 1 Then Setlog("Wait for main screen " & $mCcount, $COLOR_PURPLE)
			If $mCount >= 50 Then ExitLoop
		WEnd

		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>SWHTSearchLimit