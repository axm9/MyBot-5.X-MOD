; #FUNCTION# ====================================================================================================================
; Name ..........: getArmySpellCount
; Description ...: Obtains count of spells available from Training - Army Overview window
; Syntax ........: getArmySpellCount()
; Parameters ....:
; Return values .: None
; Author ........: Separated from checkArmyCamp()
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getArmySpellCount($bOpenArmyWindow = False, $bCloseArmyWindow = False)
	If $debugSetlog = 1 Then Setlog("Begin getArmySpellCount", $COLOR_PURPLE)

	If $bOpenArmyWindow = False And IsTrainPage() = False Then ; check for train page
		SetError(1)
		Return ; not open, not requested to be open - error.
	ElseIf $bOpenArmyWindow = True Then
		If openArmyOverview() = False Then
			SetError(2)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep($iDelaycheckArmyCamp5) Then Return
	EndIf

	If $iTotalCountSpell > 0 Or $ichkDBLightSpell = 1 Then ; only use this code if the user had input spells to brew or Zap is enabled... and assign the spells quantity
		; reset Global variables
		$CurLightningSpell = 0
		$CurHealSpell = 0
		$CurRageSpell = 0
		$CurJumpSpell = 0
		$CurFreezeSpell = 0
		$CurPoisonSpell = 0
		$CurHasteSpell = 0
		$CurEarthSpell = 0

		For $i = 0 To 4 ; 5 visible slots in ArmyOverView window
			Local $FullTemp = getOcrSpellDetection(125 + (62 * $i), 450 + $midOffsetY)
			Local $Result = getOcrSpellQuantity(146 + (62 * $i), 414 + $midOffsetY)
			Local $SpellQ = StringReplace($Result, "x", "")
			If $FullTemp = "Lightning" Then
				$CurLightningSpell = $SpellQ
				Setlog(" - No. of Lightning Spell: " & $SpellQ)
			EndIf
			If $FullTemp = "Heal" Then
				$CurHealSpell = $SpellQ
				Setlog(" - No. of Heal Spell: " & $SpellQ)
			EndIf
			If $FullTemp = "Rage" Then
				$CurRageSpell = $SpellQ
				Setlog(" - No. of Rage Spell: " & $SpellQ)
			EndIf
			If $FullTemp = "Jump" Then
				$CurJumpSpell = $SpellQ
				Setlog(" - No. of Jump Spell: " & $SpellQ)
			EndIf
			If $FullTemp = "Freeze" Then
				$CurFreezeSpell = $SpellQ
				Setlog(" - No. of Freeze Spell: " & $SpellQ)
			EndIf
			If $FullTemp = "Poison" Then
				$CurPoisonSpell = $SpellQ
				Setlog(" - No. of Poison Spell: " & $SpellQ)
			EndIf
			If $FullTemp = "Haste" Then
				$CurHasteSpell = $SpellQ
				Setlog(" - No. of Haste Spell: " & $SpellQ)
			EndIf
			If $FullTemp = "Earth" Then
				$CurEarthSpell = $SpellQ
				Setlog(" - No. of Earthquake Spell: " & $SpellQ)
			EndIf
			If $FullTemp = "" And $debugSetlog = 1 Then
				Setlog(" - was not detected anything in slot: " & $i + 1, $COLOR_PURPLE)
			EndIf
		Next
	EndIf

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ; Click Away
		If _Sleep($iDelaycheckArmyCamp4) Then Return
	EndIf
EndFunc   ;==>getArmySpellCount