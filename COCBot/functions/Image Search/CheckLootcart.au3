; #FUNCTION# ====================================================================================================================
; Name ..........: Lootcart.au3
; Description ...: This file Includes function to perform defense farming.
; Syntax ........:
; Parameters ....: None
; Return values .: False if regular farming is needed to refill storage
; Author ........: Araboy (2016)
; Modified ......: Araboy 2016
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func checkLootcart()
	SetLog("Checking for Lootcart", $COLOR_BLUE)
	Local $LootcartX = 0, $lootcartY = 0, $LootcartLoc = 0, $Tolerance = 0.87, $DefaultCocSearchArea = "15|25|825|625"
	Local $LootcartImg = @ScriptDir & "\images\Lootcart.png"
	If Not (FileExists($LootcartImg)) Then 
		SetLog("Cannot find Lootcart img " & $LootcartImg, $COLOR_RED)
		Return False
	EndIf
	
	_CaptureRegion()
	$sendHBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)
	If _Sleep($iDelayCheckLootcart1) Then Return	
	
	Local $result = DllCall($LibDir & "\ImgLocV6.dll", "str", "SearchTile", "handle", $sendHBitmap, "str", $LootcartImg , "float", $Tolerance, "str" ,$DefaultCocSearchArea, "str", $DefaultCocDiamond)
	Local $iLootcartLoc = StringSplit($result[0],"|")
	If $iLootcartLoc[1] > 0 Then
		$LootcartX = $iLootcartLoc[2]
		$LootcartY = $iLootcartLoc[3]
		SetLog("Found Lootcart, Collecting...", $COLOR_GREEN)
		If $DebugSetLog = 1 Then SetLog("Lootcart found (" & $LootcartX & "," & $LootcartY & ") Tolerance:" & $LootcartTol, $COLOR_PURPLE)
		If IsMainPage() Then Click($LootcartX, $LootcartY, 1, 0, "#0120")
		If _Sleep($iDelayCheckLootcart2) Then Return
		Click(430, 650, 1, 0, "#0120")
		ClickP($aAway, 1, 0, "#0121") ; click away
		If _Sleep($iDelayCheckLootcart1) Then Return
		Return True
	EndIf
	SetLog("Cannot find Lootcart", $COLOR_RED)
	If _Sleep($iDelayCheckLootcart1) Then Return
	checkMainScreen(False) ; check for screen errors while function was running
	Return False
EndFunc   ;==>Checklootcart