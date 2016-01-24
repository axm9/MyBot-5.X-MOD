; #FUNCTION# ====================================================================================================================
; Name ..........: isBarrack
; Description ...: Checks for your Barrack, Dark Barrack or Spell Factory
; Syntax ........: isBarrack(), isDarkBarrack(), isSpellFactory(), isDarkSpellFactory()
; Parameters ....:
; Return values .: None
; Author ........: 2015-06 Sardo
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func isBarrack()
	For $i = 1 To 4
		If _ColorCheck(_GetPixelColor($btnpos[$i][0], $btnpos[$i][1], True), Hex(0xE8E8E0, 6), 10) Then
			If $debugSetlog = 1 Then SetLog("Barrack" & $i & " selected", $COLOR_PURPLE)
			Return True ;exit when  found
		EndIf
	Next

	If $debugSetlog = 1 Then SetLog("This is not a Barrack", $COLOR_PURPLE)
	Return False
EndFunc   ;==>isBarrack

Func isDarkBarrack()
	For $i = 5 To 6
		If _ColorCheck(_GetPixelColor($btnpos[$i][0], $btnpos[$i][1], True), Hex(0xE8E8E0, 6), 10) Then
			If $debugSetlog = 1 Then SetLog("Dark Barrack" & $i - 4 & " selected", $COLOR_PURPLE)
			Return True ;exit when found
		EndIf
	Next
	If $debugSetlog = 1 Then SetLog("This is not a Dark Barrack", $COLOR_PURPLE)
	Return False
EndFunc   ;==>isDarkBarrack

Func isSpellFactory()
	If _ColorCheck(_GetPixelColor($btnpos[7][0], $btnpos[7][1], True), Hex(0xE8E8E0, 6), 10) Then
		If $debugSetlog = 1 Then SetLog("Spell FactoryDark  selected", $COLOR_PURPLE)
		Return True ;Spell Factory
	EndIf
	Return False
EndFunc   ;==>isSpellFactory

Func isDarkSpellFactory()
	If _ColorCheck(_GetPixelColor($btnpos[8][0], $btnpos[8][1], True), Hex(0xE8E8E0, 6), 10) Then
		If $debugSetlog = 1 Then SetLog("Dark Spell Factory  selected", $COLOR_PURPLE)
		Return True ;dark Spell Factory
	EndIf
	Return False
EndFunc   ;==>isDarkSpellFactory