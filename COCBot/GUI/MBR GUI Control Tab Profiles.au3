; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Tab Profile
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

Func cmbProfile()
	saveConfig()
	FileClose($hLogFileHandle)
	$hLogFileHandle = ""
	FileClose($hAttackLogFileHandle)
	$hAttackLogFileHandle = ""
	Switch _GUICtrlComboBox_GetCurSel($cmbProfile)
		Case 0
			$sCurrProfile = "01"
		Case 1
			$sCurrProfile = "02"
		Case 2
			$sCurrProfile = "03"
		Case 3
			$sCurrProfile = "04"
		Case 4
			$sCurrProfile = "05"
		Case 5
			$sCurrProfile = "06"
	EndSwitch
	DirCreate($sProfilePath & "\" & $sCurrProfile)
	$sProfilePath = @ScriptDir & "\Profiles"
	If FileExists($sProfilePath & "\profile.ini") = 0 Then
		Local $hFile = FileOpen($sProfilePath & "\profile.ini", BitOR($FO_APPEND,$FO_CREATEPATH))
		FileWriteLine($hfile, "[general]")
		FileClose($hFile)
	EndIf
	IniWrite($sProfilePath & "\profile.ini", "general", "defaultprofile", $sCurrProfile)
	$config = $sProfilePath & "\" & $sCurrProfile & "\config.ini"
	$building = $sProfilePath & "\" & $sCurrProfile & "\building.ini"
	$dirLogs = $sProfilePath & "\" & $sCurrProfile & "\Logs\"
	$dirLoots = $sProfilePath & "\" & $sCurrProfile & "\Loots\"
	$dirStats = $sProfilePath & "\" & $sCurrProfile & "\Stats\"
	$dirTemp = $sProfilePath & "\" & $sCurrProfile & "\Temp\"
	$dirTempDebug = $sProfilePath & "\" & $sCurrProfile & "\Temp\Debug\"
	DirCreate($dirLogs)
	DirCreate($dirLoots)
	DirCreate($dirStats)
	DirCreate($dirTemp)
	DirCreate($dirTempDebug)
	readConfig()
	applyConfig()
	saveConfig()
	SetLog(_PadStringCenter("Profile " & $sCurrProfile & " loaded from " & $config, 50, "="), $COLOR_GREEN)
EndFunc   ;==>cmbProfile

Func txtVillageName()
	$iVillageName = GUICtrlRead($txtVillageName)
	If $iVillageName = "" Then $iVillageName = "Main"
	GUICtrlSetData($grpVillage, "Village: " & $iVillageName)
	GUICtrlSetData($OrigPushB, $iVillageName)
	GUICtrlSetData($txtVillageName, $iVillageName)
EndFunc   ;==>txtVillageName