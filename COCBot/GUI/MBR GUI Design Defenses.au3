; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design  Def
; Description ...: This file Includes GUI Design
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

Global $chkInferno, $chkMortar, $chkWizard, $chkTesla, $chkAir, $chkArcher, $chkCannon
Global $sldDefTolerance, $hDefGUI

Func GUI3()
	$hDefGUI = GUICreate(GetTranslated(16,1, "Choose Traps to detect"), 250, 300, 85, 60, -1, $WS_EX_MDICHILD, $frmbot)
	GUISetIcon($pIconLib, $eIcnGUI)
	$gui2Open = 1
	GUISetOnEvent($GUI_EVENT_CLOSE, "CloseGUI3") ; Run this function when the secondary GUI [X] is clicked
	GUICtrlCreateLabel(GetTranslated(16,2, "Choose which defense to detect as a trap"), 5, 5, 240, 28)
	$x = 5
	$y = 35
	Local $txtTip1 = GetTranslated(16,3, "If this box is checked, then the bot will look for ")
	$chkInferno = GUICtrlCreateCheckbox(GetTranslated(16,4, "Enable Inferno Tower detection"), $x, $y)
		$txtTip = $txtTip1 & @CRLF & GetTranslated(15,5, "Inferno Tower near TownHall.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkInferno")
	$y += 25
	$chkMortar = GUICtrlCreateCheckbox(GetTranslated(16,6, "Enable Mortar detection"), $x, $y)
		$txtTip = $txtTip1 & @CRLF & GetTranslated(15,7, "Mortar near TownHall.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkMortar")
	$y += 25
	$chkWizard = GUICtrlCreateCheckbox(GetTranslated(16,8, "Enable Wizard Tower detection"), $x, $y)
		$txtTip = $txtTip1 & @CRLF & GetTranslated(16,9, "Wizard Tower near TownHall.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkWizard")
	$y += 25
	$chkTesla = GUICtrlCreateCheckbox(GetTranslated(16,10, "Enable Hidden Tesla detection"), $x, $y)
		$txtTip = $txtTip1 & @CRLF & GetTranslated(16,11, "Hidden Tesla near TownHall.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkTesla")
	$y += 25
	$chkAir = GUICtrlCreateCheckbox(GetTranslated(16,12, "Enable Air Defense detection"), $x, $y)
		$txtTip = $txtTip1 & @CRLF & GetTranslated(16,13, "Air Defense near TownHall.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkAir")
	$y += 25
	$chkArcher = GUICtrlCreateCheckbox(GetTranslated(16,14, "Enable Archer Tower detection"), $x, $y)
		$txtTip = $txtTip1 & @CRLF & GetTranslated(16,15, "Archer Tower near TownHall.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkArcher")
	$y += 25
	$chkCannon = GUICtrlCreateCheckbox(GetTranslated(16,16, "Enable Cannon detection"), $x, $y)
		$txtTip = $txtTip1 & @CRLF & GetTranslated(16,17, "Cannon near TownHall.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkCannon")

	$y += 50
	$lblTolerancedef = GUICtrlCreateLabel("-15" & _PadStringCenter(GetTranslated(16,18, "Tolerance"), 80, " ") & "15", 5, $y - 15)
	$slddefTolerance = GUICtrlCreateSlider(5, $y, 290, 20, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS)) ;,
	$txtTip = GetTranslated(16,19, "Use this slider to adjust the tolerance of ALL images.") & @CRLF & GetTranslated(16,20, "If you want to adjust individual images, you must edit the files.")
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetTip(-1, $txtTip)
		_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
		_GUICtrlSlider_SetTicFreq(-1,1)
		GUICtrlSetLimit(-1, 15,-15) ; change max/min value
		GUICtrlSetData(-1, 0) ; default value
		GUICtrlSetOnEvent(-1, "slddefTolerance")

	$y += 30
	$btnSaveExitdef = GUICtrlCreateButton(GetTranslated(16,21, "Save and Close"), 5, $y, 240, 20)
	GUICtrlSetOnEvent(-1, "CloseGUI3")
EndFunc