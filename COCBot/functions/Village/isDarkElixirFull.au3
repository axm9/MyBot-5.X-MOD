; #FUNCTION# ====================================================================================================================
; Name ..........: isDarkElixirFull
; Description ...: Checks if your Dark Elixir Storage is maxed out
; Syntax ........: isElixirFull()
; Parameters ....:
; Return values .: True or False
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func isDarkElixirFull()
	If _CheckPixel($aIsDarkElixirFull, $bCapturePixel) Then ; Check for black/purple pixel in full bar
		SetLog("Dark Elixir Storage is full!", $COLOR_GREEN)
		Return True
	EndIf
	Return False
EndFunc   ;==>isDarkElixirFull