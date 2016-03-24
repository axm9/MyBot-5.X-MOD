; #FUNCTION# ====================================================================================================================
; Name ..........: _ProcessSuspendResume2.au3
; Description ...: Functions for process supend resume
; Author ........: 
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; ===============================================================================================================================

; https://www.autoitscript.com/forum/topic/32975-process-suspendprocess-resume-udf/?do=findComment&comment=1256804
Func _ProcessSuspendResume($iPIDorName, $iSuspend = True)
   	If IsString($iPIDorName) Then $iPIDorName = ProcessExists($iPIDorName)
   	If Not $iPIDorName Then Return SetError(2, 0, 0)

   	; Consider using $PROCESS_SUSPEND_RESUME = 0x00000800 instead of $PROCESS_ALL_ACCESS
   	Local $ai_Handle = _WinAPI_OpenProcess( $PROCESS_ALL_ACCESS, False, $iPIDorName)
   	; Note: "NtSuspendProcess" is an undocumented API
   	Local $i_sucess = DllCall("ntdll.dll","int","Nt" & ($iSuspend ? "Suspend" : "Resume") & "Process","int",$ai_Handle)

   	_WinAPI_CloseHandle($ai_Handle)
   	If IsArray($i_sucess) Then Return 1
   	Return SetError(1, 0, 0)
EndFunc  ;==>_ProcessSuspendResume

; The more 'offical' & easy way (http://stackoverflow.com/a/11010508/3135511)
Func _ProcessSuspendResume2($iPIDorName, $iSuspend = True)
	If IsString($iPIDorName) Then $iPIDorName = ProcessExists($iPIDorName)
	If Not $iPIDorName Then Return SetError(2, 0, 0)
	
	If $iSuspend then
		; Note Opens Process with PROCESS_ALL_ACCESS
		DllCall('kernel32.dll', 'ptr', 'DebugActiveProcess', 'int', $iPIDorName)
	
		; you may leave out DebugSetProcessKillOnExit; however then your supended App will also Exit when you quit this AutoIt App
		DllCall('kernel32.dll', 'ptr', 'DebugSetProcessKillOnExit', 'int', False)
	Else
		DllCall('kernel32.dll', 'ptr', 'DebugActiveProcessStop', 'int', $iPIDorName)
	EndIf	
EndFunc