; #FUNCTION# ====================================================================================================================
; Name ..........: CloseCoC
; Description ...: Kill then restart CoC
; Syntax ........: CloseCoC($ReOpenCoC = False)
; Parameters ....:
; Return values .: None
; Author ........: The Master (2015)
; Modified ......: cosote (Dec 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CloseCoC($ReOpenCoC = False)
    If Not $RunState Then Return

    Local $Adb = ""
	If $ReOpenCoC Then
	   SetLog("Please wait for CoC restart......", $COLOR_RED) ; Let user know we need time...
    Else
	   SetLog("Closing CoC......", $COLOR_RED) ; Let user know what we do...
    EndIf
	
	WinGetAndroidHandle()
	BS1HomeButton()
	
	If Not $RunState Then Return
	
	SendAdbCommand("shell am force-stop com.supercell.clashofclans")
    If Not $RunState Then Return
	If $ReOpenCoC Then
        OpenCoC()
		$Restart = True
	EndIf
EndFunc   ;==>CloseCoC

; #FUNCTION# ====================================================================================================================
; Name ..........: OpenCoC
; Description ...: Open Clash of clans
; Syntax ........: OpenCoC()
; Parameters ....:
; Return values .: None
; Author ........: The Master (2015)
; Modified ......: cosote (Dec 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func OpenCoC()
    If Not $RunState Then Return

	Local $RunApp = "" , $iCount = 0
	WinGetAndroidHandle()
	BS1HomeButton()
	
	If _Sleep(250) Then Return
	
    SendAdbCommand("shell am start -n com.supercell.clashofclans/.GameApp")
    If Not $RunState Then Return
	While _CheckPixel($aIsMain, True) = False ; Wait for MainScreen
		$iCount += 1
        If _Sleep(100) Then Return
		If checkObstacles() Then $iCount += 1
		If $iCount > 250 Then ExitLoop
	WEnd
EndFunc  ;==>OpenCoC

; #FUNCTION# ====================================================================================================================
; Name ..........: WaitnOpenCoC
; Description ...: Waits for specified time before restarting Coc
; Syntax ........: WaitnOpenCoC($iWaitTime)
; Parameters ....: $iWaitTime           - Time to wait in milliseconds.
;					  ; $bFullRestart			 - Optional boolean flag if function needs to clean up mis windows after opening CoC
; Return values .: None
; Author ........: KnowJack (Aug 2015)
; Modified ......: TheMaster (2015), cosote (Dec 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func WaitnOpenCoC($iWaitTime, $bFullRestart = False)
    If Not $RunState Then Return

	Local $RunApp = ""
	WinGetAndroidHandle()
	BS1HomeButton()
	SetLog("Waiting " & Round ($iWaitTime / 1000) & " seconds before starting CoC", $COLOR_GREEN)
	If _SleepStatus($iWaitTime) Then Return False ; Wait for server to see log off
	
	SendAdbCommand("shell am start -n com.supercell.clashofclans/.GameApp")
    If Not $RunState Then Return

	If $debugSetlog = 1 Then SetLog("CoC Restarted, Waiting for completion", $COLOR_PURPLE)

	If $bFullRestart = True Then
		checkMainScreen() ; Use checkMainScreen to restart CoC, and waitMainScreen to handle Take A Break wait, or other errors.
		$Restart = True
	Else
		waitMainScreen()
	EndIf
EndFunc   ;==>WaitnOpenCoC