; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Def
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: araboy
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $chkInfernoEnabled, $chkMortarEnabled, $chkWizardEnabled, $chkTeslaEnabled, $chkAirEnabled, $chkArcherEnabled, $chkCannonEnabled, $toleranceDefOffset

Func chkInferno()
	If GUICtrlRead($chkInferno) = $GUI_CHECKED Then
		$chkInfernoEnabled = 1
	Else
		$chkInfernoEnabled = 0
	EndIf
EndFunc

Func chkMortar()
	If GUICtrlRead($chkMortar) = $GUI_CHECKED Then
		$chkMortarEnabled = 1
	Else
		$chkMortarEnabled = 0
	EndIf
EndFunc

Func chkWizard()
	If GUICtrlRead($chkWizard) = $GUI_CHECKED Then
		$chkWizardEnabled = 1
	Else
		$chkWizardEnabled = 0
	EndIf
EndFunc

Func chkTesla()
	If GUICtrlRead($chkTesla) = $GUI_CHECKED Then
		$chkTeslaEnabled = 1
	Else
		$chkTeslaEnabled = 0
	EndIf
EndFunc

Func chkAir()
	If GUICtrlRead($chkAir) = $GUI_CHECKED Then
		$chkAirEnabled = 1
	Else
		$chkAirEnabled = 0
	EndIf
EndFunc

Func chkArcher()
	If GUICtrlRead($chkArcher) = $GUI_CHECKED Then
		$chkArcherEnabled = 1
	Else
		$chkArcherEnabled = 0
	EndIf
EndFunc

Func chkCannon()
	If GUICtrlRead($chkCannon) = $GUI_CHECKED Then
		$chkCannonEnabled = 1
	Else
		$chkCannonEnabled = 0
	EndIf
EndFunc

Func sldDefTolerance()
	$toleranceDefOffset = GUICtrlRead($sldDefTolerance)
EndFunc

Func readDefConfig()
	$chkInfernoEnabled = IniRead($config,"def", "TrapInfernoEnabled", 0)
	$chkMortarEnabled = IniRead($config,"def", "TrapMortarEnabled", 1)
	$chkWizardEnabled = IniRead($config,"def", "TrapWizardEnabled", 0)
	$chkTeslaEnabled = IniRead($config,"def", "TrapTeslaEnabled", 1)
	$chkAirEnabled = IniRead($config,"def", "TrapAirEnabled", 0)
	$chkArcherEnabled = IniRead($config,"def", "TrapArcherEnabled", 1)
	$chkCannonEnabled = IniRead($config,"def", "TrapCannonEnabled", 0)
	$toleranceDefOffset = IniRead($config, "def", "TrapDefTolerance", 0)
EndFunc

Func saveDefConfig()
	Iniwrite($config, "def", "TrapInfernoEnabled", $chkInfernoEnabled)
	Iniwrite($config, "def", "TrapMortarEnabled", $chkMortarEnabled)
	Iniwrite($config, "def", "TrapWizardEnabled", $chkWizardEnabled)
	Iniwrite($config, "def", "TrapTeslaEnabled", $chkTeslaEnabled)
	Iniwrite($config, "def", "TrapAirEnabled", $chkAirEnabled)
	Iniwrite($config, "def", "TrapArcherEnabled", $chkArcherEnabled)
	Iniwrite($config, "def", "TrapCannonEnabled", $chkCannonEnabled)
	IniWrite($config, "def", "TrapDefTolerance", $toleranceDefOffset)
EndFunc

Func applyDefConfig()
	If $chkInfernoEnabled = 1 Then
		GUICtrlSetState($chkInferno, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkInferno, $GUI_UNCHECKED)
	EndIf
	
	If $chkMortarEnabled = 1 Then
		GUICtrlSetState($chkMortar, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkMortar, $GUI_UNCHECKED)
	EndIf
	
	If $chkWizardEnabled = 1 Then
		GUICtrlSetState($chkWizard, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkWizard, $GUI_UNCHECKED)
	EndIf
	
	If $chkTeslaEnabled = 1 Then
		GUICtrlSetState($chkTesla, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkTesla, $GUI_UNCHECKED)
	EndIf
	
	If $chkAirEnabled = 1 Then
		GUICtrlSetState($chkAir, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkAir, $GUI_UNCHECKED)
	EndIf
	
	If $chkArcherEnabled = 1 Then
		GUICtrlSetState($chkArcher, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkArcher, $GUI_UNCHECKED)
	EndIf
	
	If $chkCannonEnabled = 1 Then
		GUICtrlSetState($chkCannon, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkCannon, $GUI_UNCHECKED)
	EndIf

	GUICtrlSetData($sldDefTolerance, $toleranceDefOffset)
EndFunc

Func OpenGUI3()
	GUI3()
	applyDefConfig()
	GUISetState(@SW_SHOW, $hdefGUI)
	GUISetState(@SW_DISABLE, $frmBot)
EndFunc

Func CloseGUI3()
	$gui2open = 0
	savedefConfig()
	GUIDelete($hdefGUI)
	GUISetState(@SW_ENABLE, $frmBot)
	WinActivate($frmBot)
EndFunc