;#FUNCTION# =================================================================================================================
; Name ..........: checkDefense
; Description ...: This file Includes the Variables and functions to detect certain defenses near TH, based on checkTownhall.au3
; Syntax ........: checkDefense()
; Parameters ....: None
; Return values .: $Defx, $Defy
; Author ........: barracoda
; Modified ......: by zombie then remodified by The Araboy
; Remarks .......: This file is part of mybotrun Copyright 2016
;                  mybotrun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Global $ppath[7] = ["inferno" , "tesla" , "mortar" , "wizard" ,  "air" , "archer" , "cannon"]
Global $Defx = 0, $Defy = 0
Global $DefText[7] ; Text of Defense Type
$DefText[0] = "Inferno Tower"
$DefText[1] = "Wizard Tower"
$DefText[2] = "Mortar"
$DefText[3] = "Hidden Tesla"
$DefText[4] = "Air Defense"
$DefText[5] = "Archer Tower"
$DefText[6] = "Cannon"

Global $DefImages0, $DefImages1, $DefImages2, $DefImages3, $DefImages4, $DefImages5, $DefImages6
Global $defTolerance

Func IsTHTrapped()
	SetLog("Checking Trapped TH", $COLOR_BLUE)
	$Defx = 0, $Defy = 0

	$iLeft = $THx - 125
	$iTop = $THy - 90
	$iRight = $THx + 125
	$iBottom = $THy + 90

	If $iLeft < 80 Then
		$iLeft = 80
	EndIf
	If $iTop < 70 Then
		$iTop = 70
	EndIf
	If $iRight > 780  then
		$iRight = 780
	EndIf
	If $iBottom > 600 Then
		$iBottom = 600
	EndIf

	$iw = $iRight - $iLeft
	$ih = $iBottom - $iTop

	_CaptureTH($iLeft, $iTop, $iRight, $iBottom, False)
	
	For $t = 0 To 6
		If Execute("$DefImages" & $t & "[0]") > 0 Then
			For $i = 1 To Execute("$DefImages" & $t & "[0]")
				$defToleranceArray = StringSplit(Execute("$DefImages" & $t & "["& $i & "]") , "T")
				$defTolerance = $defToleranceArray[2] + $toleranceDefOffset

				$DefLocation = _ImageSearchArea(@ScriptDir & "\images\Defense\" & $ppath[$t] & "\" & Execute("$DefImages" & $t & "["& $i & "]"), 1, 0, 0, $iw, $ih, $Defx, $Defy, $defTolerance) ; Getting Defense Location

				If $DefLocation = 1 Then
					If $chkInfernoEnabled = 1 And $t = 0 Then
						If ($Defx > 40 And $Defx < 210) And ($Defy > 30 And $Defy < 150) Then
							SetLog("Inferno Tower found near TH...", $COLOR_RED)
							Return True
						EndIf
					ElseIf $chkTeslaEnabled = 1 And $t = 1 Then
						If ($Defx > 58 And $Defx < 192) And ($Defy > 45 And $Defy < 135) Then
							SetLog("Hidden Tesla found near TH...", $COLOR_RED)
							Return True
						EndIf
					ElseIf $chkMortarEnabled = 1 And $t = 2 Then
						If ($Defx > 5 And $Defx < 245) And ($Defy > 10 And $Defy < 170) Then
							SetLog("Mortar found near TH...", $COLOR_RED)
							Return True
						EndIf
					ElseIf $chkWizardEnabled = 1 And $t = 3 Then
						If ($Defx > 53 And $Defx < 197) And ($Defy > 42 And $Defy < 138) Then
							SetLog("Wizard Tower found near TH...", $COLOR_RED)
							Return True
						EndIf
					ElseIf $chkAirEnabled = 1 And $t = 4 Then
						If ($Defx > 15 And $Defx < 235) And ($Defy > 20 And $Defy < 160) Then
							SetLog("Air Defense found near TH...", $COLOR_RED)
							Return True
						EndIf
					ElseIf $chkArcherEnabled = 1 And $t = 5 Then
						If ($Defx > 15 And $Defx < 235) And ($Defy > 20 And $Defy < 160) Then
							SetLog("Archer Tower found near TH...", $COLOR_RED)
							Return True
						EndIf
					ElseIf $chkCannonEnabled = 1 And $t = 6 Then
						If ($Defx > 40 And $Defx < 210) And ($Defy > 30 And $Defy < 150) Then
							SetLog("Cannon found near TH...", $COLOR_RED)
							Return True
						EndIf
					EndIf
				EndIf
			Next
		EndIf
	Next
	
	SetLog("No major trap found near TH", $COLOR_GREEN)
	Return False
EndFunc   ;==>IsTHTrapped

Func _CaptureTH($iLeft = $THx - 125, $iTop = $THy - 90, $iRight = $THx + 125, $iBottom = $THy + 90, $ReturnBMP = False)
	_GDIPlus_BitmapDispose($hBitmap)
	_WinAPI_DeleteObject($hHBitmap)

	If $ichkBackground = 1 Then
		Local $iW = Number($iRight) - Number($iLeft), $iH = Number($iBottom) - Number($iTop)

		Local $hDC_Capture = _WinAPI_GetWindowDC(ControlGetHandle($Title, "", "[CLASS:BlueStacksApp; INSTANCE:1]"))
		Local $hMemDC = _WinAPI_CreateCompatibleDC($hDC_Capture)
		$hHBitmap = _WinAPI_CreateCompatibleBitmap($hDC_Capture, $iW, $iH)
		Local $hObjectOld = _WinAPI_SelectObject($hMemDC, $hHBitmap)

		DllCall("user32.dll", "int", "PrintWindow", "hwnd", $HWnD, "handle", $hMemDC, "int", 0)
		_WinAPI_SelectObject($hMemDC, $hHBitmap)
		_WinAPI_BitBlt($hMemDC, 0, 0, $iW, $iH, $hDC_Capture, $iLeft, $iTop, 0x00CC0020)

		Global $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmap)

		_WinAPI_DeleteDC($hMemDC)
		_WinAPI_SelectObject($hMemDC, $hObjectOld)
		_WinAPI_ReleaseDC($HWnD, $hDC_Capture)
	Else
		getBSPos()
		$hHBitmap = _ScreenCapture_Capture("", $iLeft + $BSpos[0], $iTop + $BSpos[1], $iRight + $BSpos[0], $iBottom + $BSpos[1])
		Global $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmap)
	EndIf

	If $ReturnBMP Then Return $hBitmap
EndFunc   ;==>_CaptureTH