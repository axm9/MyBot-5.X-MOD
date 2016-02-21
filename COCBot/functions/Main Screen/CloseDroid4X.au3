; #FUNCTION# ====================================================================================================================
; Name ..........: CloseDroid4X
; Description ...: Forces Droid4X processes to close, and watches processes and services to make sure it has stopped
; Syntax ........: CloseDroid4X()
; Parameters ....: None
; Return values .: @error = 1 if failure
; Author ........: cosote
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CloseDroid4X()
	Local $iIndex, $bOops = False, $process_killed
	Local $aServiceList[0] = [] ; ["BstHdAndroidSv", "BstHdLogRotatorSvc", "BstHdUpdaterSvc", "bthserv"]

	SetLog("Stopping Droid4X...", $COLOR_BLUE)

	$bOops = KillDroid4XProcess()

    SetLog("Please wait for full Droid4X shutdown...", $COLOR_GREEN)

	If _Sleep(1000) Then Return ; wait a bit

	For $iIndex = 0 To UBound($aServiceList) - 1
		ServiceStop($aServiceList[$iIndex])
		If @error Then
			$bOops = True
			If $debugsetlog = 1 Then Setlog($aServiceList[$iIndex] & " errored trying to stop", $COLOR_MAROON)
		EndIf
	Next
	If $bOops Then
		If $debugsetlog = 1 Then Setlog("Service Stop issues, Stopping Droid4X 2nd time", $COLOR_MAROON)
		KillDroid4XProcess()
		If _SleepStatus(5000) Then Return
	EndIf

    ; also stop virtualbox instance
	LaunchConsole($__VBoxManage_Path, "controlvm " & $AndroidInstance & " poweroff", $process_killed)
	If _SleepStatus(3000) Then Return

	If $debugsetlog = 1 And $bOops Then
		SetLog("Droid4X Kill Failed to stop service", $COLOR_RED)
	ElseIf Not $bOops Then
		SetLog("Droid4X stopped successfully", $COLOR_GREEN)
	EndIf

	RemoveGhostTrayIcons($Title)  ; Remove ghost icon if left behind due forced taskkill

	If $bOops Then
		SetError(1, @extended, -1)
	EndIf
EndFunc   ;==>CloseDroid4X

Func KillDroid4XProcess()
	; kill only my instances
	Local $pid = WinGetProcess(WinGetAndroidHandle())
	If $pid <> -1 Then
		If ProcessClose($pid) = 0 Then
			ShellExecute(@WindowsDir & "\System32\taskkill.exe", "-f -t -pid " & $pid, "", Default, @SW_HIDE)
		EndIf
	EndIf
	If ProcessExists($AndroidAdbPid) Then
		If ProcessClose($AndroidAdbPid) = 0 Then
			ShellExecute(@WindowsDir & "\System32\taskkill.exe", "-f -t -pid " & $AndroidAdbPid, "", Default, @SW_HIDE)
		EndIf
	EndIF
EndFunc   ;==>KillDroid4XProcess