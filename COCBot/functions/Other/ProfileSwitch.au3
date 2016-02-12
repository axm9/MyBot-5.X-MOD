; #FUNCTION# ====================================================================================================================
; Name ..........: ProfileSwitch.au3
; Description ...: Swith profile based on settings
; Syntax ........: ProfileSwitch()
; Parameters ....: 
; Return values .: NA
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func ProfileSwitch()
	If $ichkGoldSwitchMax = 1 Or $ichkGoldSwitchMin = 1 Or $ichkElixirSwitchMax = 1 Or $ichkElixirSwitchMin = 1 Or _
	$ichkDESwitchMax = 1 Or $ichkDESwitchMin = 1 Or $ichkTrophySwitchMax = 1 Or $ichkTrophySwitchMin = 1 Then
		Local $SwitchtoProfile = ""
		Local $curProfile = Int($sCurrProfile) - 1
		While True
			If $ichkGoldSwitchMax = 1 Then
				If Number($iGoldCurrent) >= Number($itxtMaxGoldAmount) And $curProfile <> Int($icmbGoldMaxProfile) Then
					$SwitchtoProfile = $icmbGoldMaxProfile
					Setlog("Village Gold detected Above Gold Profile Switch Condition")
					ExitLoop
				EndIf
			EndIf
			If $ichkGoldSwitchMin = 1 Then
				If Number($iGoldCurrent) <= Number($itxtMinGoldAmount) And $curProfile <> Int($icmbGoldMinProfile) Then
					$SwitchtoProfile = $icmbGoldMinProfile
					Setlog("Village Gold detected Below Gold Profile Switch Condition")
					ExitLoop
				EndIf
			EndIf
			If $ichkElixirSwitchMax = 1 Then
				If Number($iElixirCurrent) >= Number($itxtMaxElixirAmount) And $curProfile <> Int($icmbElixirMaxProfile) Then
					$SwitchtoProfile = $icmbElixirMaxProfile
					Setlog("Village Gold detected Above Elixir Profile Switch Condition")
					ExitLoop
				EndIf
			EndIf
			If $ichkElixirSwitchMin = 1 Then
				If Number($iElixirCurrent) <= Number($itxtMinElixirAmount) And $curProfile <> Int($icmbElixirMinProfile) Then
					$SwitchtoProfile = $icmbElixirMinProfile
					Setlog("Village Gold detected Below Elixir Switch Condition")
					ExitLoop
				EndIf
			EndIf
			If $ichkDESwitchMax = 1 Then
				If Number($iDarkCurrent) >=	Number($itxtMaxDEAmount) And $curProfile <> Int($icmbDEMaxProfile) Then
					$SwitchtoProfile = $icmbDEMaxProfile
					Setlog("Village Dark Elixir detected Above Dark Elixir Profile Switch Condition")
					ExitLoop
				EndIf
			EndIf
			If $ichkDESwitchMin = 1 Then
				If Number($iDarkCurrent) <=	Number($itxtMinDEAmount) And $curProfile <> Int($icmbDEMinProfile) Then
					$SwitchtoProfile = $icmbDEMinProfile
					Setlog("Village Dark Elixir detected Below Dark Elixir Profile Switch Condition")
					ExitLoop
				EndIf
			EndIf
			If $ichkTrophySwitchMax = 1 Then
				If Number($iTrophyCurrent) >= Number($itxtMaxTrophyAmount) And $curProfile <> Int($icmbTrophyMaxProfile) Then
					$SwitchtoProfile = $icmbTrophyMaxProfile
					Setlog("Village Trophies detected Above Throphy Profile Switch Condition")
					ExitLoop
				EndIf
			EndIf
			If $ichkTrophySwitchMin = 1 Then
				If Number($iTrophyCurrent) <= Number($itxtMinTrophyAmount) And $curProfile <> Int($icmbTrophyMinProfile) Then
					$SwitchtoProfile = $icmbTrophyMinProfile
					Setlog("Village Trophies detected Below Trophy Profile Switch Condition")
					ExitLoop
				EndIf
			EndIf
			ExitLoop
		WEnd

		If $SwitchtoProfile <> "" Then
			If $curProfile <> Int($SwitchtoProfile) Then ; switch profile if we are not using it already
				If $AlertSearch = 1 Then
					TrayTip($sBotTitle, "Switch profile condition detected", 0)
				EndIf
				_GUICtrlComboBox_SetCurSel($cmbProfile, $SwitchtoProfile)
				cmbProfile()
			EndIf
		EndIf
	EndIf
EndFunc