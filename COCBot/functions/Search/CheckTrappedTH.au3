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

Global $ppath[7] = ["inferno", "mortar", "wizard", "tesla", "air", "archer", "cannon"]
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
	Local $hTimer = TimerInit()
	Local $defCount = 0
	Local $imageName
	Local $chkDefEnabled[7] = [$chkInfernoEnabled, $chkMortarEnabled, $chkWizardEnabled, $chkTeslaEnabled, $chkAirEnabled, $chkArcherEnabled, $chkCannonEnabled]
	
	$Defx = 0
	$Defy = 0
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

	_CaptureTH($iLeft, $iTop, $iRight, $iBottom, False)
	
	For $t = 0 To 6
		If $chkDefEnabled[$t] = 0 Then
			If $debugsetlog = 1 Then Setlog("Skip detecting " & $ppath[$t], $COLOR_PURPLE)
			ContinueLoop ; skip trap detection if defense was not selected
		EndIf
		If Execute("$DefImages" & $t & "[0]") > 0 Then
			For $i = 1 To Execute("$DefImages" & $t & "[0]")
				$defToleranceArray = StringSplit(Execute("$DefImages" & $t & "["& $i & "]") , "T")
				$defTolerance = $defToleranceArray[2] + $toleranceDefOffset
				$imageName = Execute("$DefImages" & $t & "["& $i & "]")
				If $debugsetlog = 1 Then Setlog("Search for " & $ppath[$t] & " in rectangle (" & $iLeft & "," & $iTop & ") - (" & $iRight & "," & $iBottom & ")", $COLOR_PURPLE)
				$DefLocation = _ImageSearchArea(@ScriptDir & "\images\Defense\" & $ppath[$t] & "\" & $imageName, 1, $iLeft, $iTop, $iRight, $iBottom, $Defx, $Defy, $defTolerance) ; Getting Defense Location
				$defCount += 1

				If $DefLocation = 1 Then
					If $debugBuildingPos = 1 Then
						Setlog("#*# IsTHTrapped result: ", $COLOR_TEAL)
						Setlog(" - TH Position (" & $THx & "," & $THy & ")", $COLOR_TEAL)
						Setlog(" - Def Position (" & $Defx & "," & $Defy & ")", $COLOR_TEAL)
						Setlog(" - Detected defense: " & $DefText[$t], $COLOR_TEAL)
						Setlog(" - Image Match " & $ppath[$t] & "\" & $imageName, $COLOR_TEAL)
						Setlog(" - IsInsidediamond: " & isInsideDiamondXY($Defx, $Defy), $COLOR_TEAL)
						SetLog(" - Calculated in: " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_TEAL)
						SetLog(" - Images checked: " & $defCount, $COLOR_TEAL)
					EndIf
					If isInsideDiamondXY($Defx, $Defy) Then
						If $chkInfernoEnabled = 1 And $t = 0 Then
							;If ($Defx > 40 And $Defx < 210) And ($Defy > 30 And $Defy < 150) Then
							If Not(isOutsideEllipse($Defx, $Defy, 90, 67.5, $THx, $THy)) Then
								SetLog("Inferno Tower found near TH...", $COLOR_RED)
								Return True
							EndIf
						ElseIf $chkMortarEnabled = 1 And $t = 1 Then
							;If ($Defx > 5 And $Defx < 245) And ($Defy > 10 And $Defy < 170) Then
							If Not(isOutsideEllipse($Defx, $Defy, 110, 82.5, $THx, $THy)) Then
								SetLog("Mortar found near TH...", $COLOR_RED)
								Return True
							EndIf
						ElseIf $chkWizardEnabled = 1 And $t = 2 Then
							;If ($Defx > 53 And $Defx < 197) And ($Defy > 42 And $Defy < 138) Then
							If Not(isOutsideEllipse($Defx, $Defy, 70, 52.5, $THx, $THy)) Then
								SetLog("Wizard Tower found near TH...", $COLOR_RED)
								Return True
							EndIf
						ElseIf $chkTeslaEnabled = 1 And $t = 3 Then
							;If ($Defx > 58 And $Defx < 192) And ($Defy > 45 And $Defy < 135) Then
							If Not(isOutsideEllipse($Defx, $Defy, 70, 52.5, $THx, $THy)) Then
								SetLog("Hidden Tesla found near TH...", $COLOR_RED)
								Return True
							EndIf
						ElseIf $chkAirEnabled = 1 And $t = 4 Then
							;If ($Defx > 15 And $Defx < 235) And ($Defy > 20 And $Defy < 160) Then
							If Not(isOutsideEllipse($Defx, $Defy, 10, 75, $THx, $THy)) Then
								SetLog("Air Defense found near TH...", $COLOR_RED)
								Return True
							EndIf
						ElseIf $chkArcherEnabled = 1 And $t = 5 Then
							;If ($Defx > 15 And $Defx < 235) And ($Defy > 20 And $Defy < 160) Then
							If Not(isOutsideEllipse($Defx, $Defy, 100, 75, $THx, $THy)) Then
								SetLog("Archer Tower found near TH...", $COLOR_RED)
								Return True
							EndIf
						ElseIf $chkCannonEnabled = 1 And $t = 6 Then
							;If ($Defx > 40 And $Defx < 210) And ($Defy > 30 And $Defy < 150) Then
							If Not(isOutsideEllipse($Defx, $Defy, 90, 67.5, $THx, $THy)) Then
								SetLog("Cannon found near TH...", $COLOR_RED)
								Return True
							EndIf
						EndIf
					Else
						ContinueLoop
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

Func LoadDefImage()
	If $debugsetlog = 1 Then Setlog("Loading Defense images", $COLOR_PURPLE)
	Local $x
	Local $useimages = "*NORM*.bmp"

	For $t = 0 To 6
		; assign DefImages0... DefImages6 to an array empty with Defimagesx[0]=0
		Assign("DefImages" & $t, StringSplit("", ""))
		; put in a temp array the list of files matching condition "*T*.bmp or *NORM*.bmp"
		$x = _FileListToArrayRec(@ScriptDir & "\images\Defense\" & $ppath[$t] & "\", $useimages, $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
		; assign value at DefImages0... DefImages6 if $x it's not empty
		If UBound($x) Then Assign("DefImages" & $t , $x)
		If $debugsetlog = 1 Then Setlog("Def image:" & _ArrayToString($x), $COLOR_PURPLE)
	Next
EndFunc   ;==>LoadDefImage

Func CaptureDefs()
	SetLog("Capturing Defenses", $COLOR_BLUE)	
	Local $hTimer = TimerInit()
	Local $defCount = 0
	Local $imageName
	Local $chkDefEnabled[7] = [$chkInfernoEnabled, $chkMortarEnabled, $chkWizardEnabled, $chkTeslaEnabled, $chkAirEnabled, $chkArcherEnabled, $chkCannonEnabled]
	
	$Defx = 0
	$Defy = 0
	
	For $t = 0 To 6
		If $chkDefEnabled[$t] = 0 Then
			If $debugsetlog = 1 Then Setlog("Skip detecting " & $ppath[$t], $COLOR_PURPLE)
			ContinueLoop ; skip trap detection if defense was not selected
		EndIf
		If Execute("$DefImages" & $t & "[0]") > 0 Then
			For $i = 1 To Execute("$DefImages" & $t & "[0]")
				$defToleranceArray = StringSplit(Execute("$DefImages" & $t & "["& $i & "]") , "T")
				$defTolerance = $defToleranceArray[2] + $toleranceDefOffset
				$imageName = Execute("$DefImages" & $t & "["& $i & "]")
				$DefLocation = _ImageSearch(@ScriptDir & "\images\Defense\" & $ppath[$t] & "\" & $imageName, 1, $Defx, $Defy, $defTolerance) ; Getting Defense Location
				$defCount += 1

				If $DefLocation = 1 Then
					Setlog(" - Def Position (" & $Defx & "," & $Defy & ")", $COLOR_TEAL)
					Setlog(" - Detected defense: " & $DefText[$t], $COLOR_TEAL)
					Setlog(" - Image Match " & $ppath[$t] & "\" & $imageName, $COLOR_TEAL)
					Setlog(" - IsInsideDiamond: " & isInsideDiamondXY($Defx, $Defy), $COLOR_TEAL)
				EndIf
			Next
		EndIf
	Next	
	
	Setlog("#*# CaptureDefs result: ", $COLOR_TEAL)
	SetLog(" - Calculated in: " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_TEAL)
	SetLog(" - Images checked: " & $defCount, $COLOR_TEAL)
EndFunc   ;==>CaptureDefs