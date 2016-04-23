; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func chkAttackHours()
	If GUICtrlRead($chkAttackHours) = $GUI_CHECKED Then
		For $i = $lbAttackHours1 To $lbAttackHoursPM
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		For $i = $lbAttackHours1 To $lbAttackHoursPM
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>chkAttackHours

Func chkAttackNow()
	If GUICtrlRead($chkAttackNow) = $GUI_CHECKED Then
		$iChkAttackNow = 1
		GUICtrlSetState($lblAttackNow, $GUI_ENABLE)
		GUICtrlSetState($lblAttackNowSec, $GUI_ENABLE)
		GUICtrlSetState($cmbAttackNowDelay, $GUI_ENABLE)
		GUICtrlSetState($cmbAttackNowDelay, $GUI_ENABLE)
	Else
		$iChkAttackNow = 0
		GUICtrlSetState($lblAttackNow, $GUI_DISABLE)
		GUICtrlSetState($lblAttackNowSec, $GUI_DISABLE)
		GUICtrlSetState($cmbAttackNowDelay, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkAttackNow

Func chkSnipeWhileTrain()
	If GUICtrlRead($ChkSnipeWhileTrain) = $GUI_CHECKED Then
		$iChkSnipeWhileTrain = 1
		GUICtrlSetState($lblSearchlimit, $GUI_ENABLE)
		GUICtrlSetState($txtSearchlimit, $GUI_ENABLE)
		GUICtrlSetState($lblminArmyCapacityTHSnipe, $GUI_ENABLE)
		GUICtrlSetState($txtminArmyCapacityTHSnipe, $GUI_ENABLE)
		GUICtrlSetState($chkSWTSmartAttack, $GUI_ENABLE)
	Else
		$iChkSnipeWhileTrain = 0
		GUICtrlSetState($lblSearchlimit, $GUI_DISABLE)
		GUICtrlSetState($txtSearchlimit, $GUI_DISABLE)
		GUICtrlSetState($lblminArmyCapacityTHSnipe, $GUI_DISABLE)
		GUICtrlSetState($txtminArmyCapacityTHSnipe, $GUI_DISABLE)
		GUICtrlSetState($chkSWTSmartAttack, $GUI_DISABLE)
	EndIf
	GUICtrlSetState($ChkSnipeWhileTrain, $GUI_ENABLE)

EndFunc   ;==>chkSnipeWhileTrain

Func chkBullyMode()
	If GUICtrlRead($chkBullyMode) = $GUI_CHECKED Then
		$OptBullyMode = 1
		GUICtrlSetState($txtATBullyMode, $GUI_ENABLE)
		GUICtrlSetState($cmbYourTH, $GUI_ENABLE)
		GUICtrlSetState($radUseDBAttack, $GUI_ENABLE)
		GUICtrlSetState($radUseLBAttack, $GUI_ENABLE)
	Else
		$OptBullyMode = 0
		GUICtrlSetState($txtATBullyMode, $GUI_DISABLE)
		GUICtrlSetState($cmbYourTH, $GUI_DISABLE)
		GUICtrlSetState($radUseDBAttack, $GUI_DISABLE)
		GUICtrlSetState($radUseLBAttack, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkBullyMode

Func chkSnipeMode()
	If GUICtrlRead($chkTrophyMode) = $GUI_CHECKED Then
		$OptTrophyMode = 1
		GUICtrlSetState($txtTHaddtiles, $GUI_ENABLE)
		GUICtrlSetState($cmbTSMeetGE, $GUI_ENABLE)
		GUICtrlSetState($chkTSAttackIfDB, $GUI_ENABLE)
		GUICtrlSetState($txtTSMinGold, $GUI_ENABLE)
		GUICtrlSetState($txtTSMinElixir, $GUI_ENABLE)
		GUICtrlSetState($txtTSMinGoldPlusElixir, $GUI_ENABLE)
		GUICtrlSetState($lblTSMinGPE, $GUI_ENABLE)
		GUICtrlSetState($chkTSMeetDE, $GUI_ENABLE)
		GUICtrlSetState($txtTSMinDarkElixir, $GUI_ENABLE)
		GUICtrlSetState($txtTSSuccessPercent, $GUI_ENABLE)
		GUICtrlSetState($txtMinTroopAttackDB, $GUI_ENABLE)
		GUICtrlSetState($cmbAttackTHType, $GUI_ENABLE)
		GUICtrlSetState($chkUseClastleTH, $GUI_ENABLE)
		GUICtrlSetState($chkUseQueenTH, $GUI_ENABLE)
		GUICtrlSetState($chkUseKingTH, $GUI_ENABLE)
		GUICtrlSetState($chkUseRSpellsTH, $GUI_ENABLE)
		GUICtrlSetState($chkUseHSpellsTH, $GUI_ENABLE)
		GUICtrlSetState($chkUseLSpellsTH, $GUI_ENABLE)
	Else
		$OptTrophyMode = 0
		GUICtrlSetState($txtTHaddtiles, $GUI_DISABLE)
		GUICtrlSetState($cmbTSMeetGE, $GUI_DISABLE)
		GUICtrlSetState($chkTSAttackIfDB, $GUI_DISABLE)
		GUICtrlSetState($txtTSMinGold, $GUI_DISABLE)
		GUICtrlSetState($txtTSMinElixir, $GUI_DISABLE)
		GUICtrlSetState($txtTSMinGoldPlusElixir, $GUI_DISABLE)
		GUICtrlSetState($lblTSMinGPE, $GUI_DISABLE)
		GUICtrlSetState($chkTSMeetDE, $GUI_DISABLE)
		GUICtrlSetState($txtTSMinDarkElixir, $GUI_DISABLE)
		GUICtrlSetState($txtTSSuccessPercent, $GUI_DISABLE)
		GUICtrlSetState($txtMinTroopAttackDB, $GUI_DISABLE)
		GUICtrlSetState($cmbAttackTHType, $GUI_DISABLE)
		GUICtrlSetState($chkUseClastleTH, $GUI_DISABLE)
		GUICtrlSetState($chkUseQueenTH, $GUI_DISABLE)
		GUICtrlSetState($chkUseKingTH, $GUI_DISABLE)
		GUICtrlSetState($chkUseRSpellsTH, $GUI_DISABLE)
		GUICtrlSetState($chkUseHSpellsTH, $GUI_DISABLE)
		GUICtrlSetState($chkUseLSpellsTH, $GUI_DISABLE)
	EndIf
	chkTSAttackIfDB()
EndFunc   ;==>chkSnipeMode

Func chkTSEnableAfter()
	If GUICtrlRead($chkTSEnableAfter) = $GUI_CHECKED Then
		_GUICtrlEdit_SetReadOnly($txtTSEnableAfter, False)
	Else
		_GUICtrlEdit_SetReadOnly($txtTSEnableAfter, True)
	EndIf
EndFunc   ;==>chkTSEnableAfter

Func cmbTSGoldElixir()
	If _GUICtrlComboBox_GetCurSel($cmbTSMeetGE) < 2 Then
		GUICtrlSetState($txtTSMinGold, $GUI_SHOW)
		GUICtrlSetState($picTSMinGold, $GUI_SHOW)
		GUICtrlSetState($txtTSMinElixir, $GUI_SHOW)
		GUICtrlSetState($picTSMinElixir, $GUI_SHOW)
		GUICtrlSetState($txtTSMinGoldPlusElixir, $GUI_HIDE)
		GUICtrlSetState($picTSMinGPEGold, $GUI_HIDE)
		GUICtrlSetState($lblTSMinGPE, $GUI_HIDE)
		GUICtrlSetState($picTSMinGPEElixir, $GUI_HIDE)
	Else
		GUICtrlSetState($txtTSMinGold, $GUI_HIDE)
		GUICtrlSetState($picTSMinGold, $GUI_HIDE)
		GUICtrlSetState($txtTSMinElixir, $GUI_HIDE)
		GUICtrlSetState($picTSMinElixir, $GUI_HIDE)
		GUICtrlSetState($txtTSMinGoldPlusElixir, $GUI_SHOW)
		GUICtrlSetState($picTSMinGPEGold, $GUI_SHOW)
		GUICtrlSetState($lblTSMinGPE, $GUI_SHOW)
		GUICtrlSetState($picTSMinGPEElixir, $GUI_SHOW)
	EndIf
EndFunc   ;==>cmbTSGoldElixir

Func chkTSMeetDE()
	If GUICtrlRead($chkTSMeetDE) = $GUI_CHECKED Then
		_GUICtrlEdit_SetReadOnly($txtTSMinDarkElixir, False)
	Else
		_GUICtrlEdit_SetReadOnly($txtTSMinDarkElixir, True)
	EndIf
EndFunc   ;==>chkTSMeetDE

Func chkTSSkipTrappedTH()
	If GUICtrlRead($chkTSSkipTrappedTH) = $GUI_CHECKED Then
		$ichkTSSkipTrappedTH = 1		
		readDefConfig()
		GUICtrlSetState($btnConfigureDef, $GUI_ENABLE)
	Else
		$ichkTSSkipTrappedTH = 0
		GUICtrlSetState($btnConfigureDef, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkTSSkipTrappedTH

Func btnConfigureDef()
	OpenGUI3()
EndFunc   ;==>btnConfigureDef

Func chkTSAttackIfDB()
	If GUICtrlRead($chkTSAttackIfDB) = $GUI_CHECKED Then
		$ichkAttackIfDB = 1
		GUICtrlSetState($lblTSSuccessPercent, $GUI_ENABLE)
		GUICtrlSetState($lblMinTroopAttackDB, $GUI_ENABLE)
		_GUICtrlEdit_SetReadOnly($txtTSSuccessPercent, False)
		_GUICtrlEdit_SetReadOnly($txtMinTroopAttackDB, False)
	Else
		$ichkAttackIfDB = 0
		GUICtrlSetState($lblTSSuccessPercent, $GUI_DISABLE)
		GUICtrlSetState($lblMinTroopAttackDB, $GUI_DISABLE)
		_GUICtrlEdit_SetReadOnly($txtTSSuccessPercent, True)
		_GUICtrlEdit_SetReadOnly($txtMinTroopAttackDB, True)
	EndIf
EndFunc   ;==>chkTSAttackIfDB

Func LoadThSnipeAttacks()
	Dim $FileSearch, $NewFile
	$FileSearch = FileFindFirstFile($dirTHSnipesAttacks & "\*.csv")
	Dim $output = ""
	While True
		$NewFile = FileFindNextFile($FileSearch)
		If @error Then ExitLoop
		$output = $output & StringLeft($NewFile, StringLen($NewFile) - 4) & "|"
	WEnd
	FileClose($FileSearch)
	; remove last |
	$output = StringLeft($output, StringLen($output) - 1)
	; reset combo box
	_GUICtrlComboBox_ResetContent($cmbAttackTHType)
	; set combo box
	GUICtrlSetData($cmbAttackTHType, $output)

	_GUICtrlComboBox_SetCurSel($cmbAttackTHType, _GUICtrlComboBox_FindStringExact($cmbAttackTHType, $scmbAttackTHType))
EndFunc   ;==>LoadThSnipeAttacks

Func cmbAttackTHType()
	Local $arrayattack = _GUICtrlComboBox_GetListArray($cmbAttackTHType)
	$scmbAttackTHType = $arrayattack[_GUICtrlComboBox_GetCurSel($cmbAttackTHType) + 1]
EndFunc