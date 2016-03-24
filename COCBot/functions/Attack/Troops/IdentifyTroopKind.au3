#cs new code for Troopsbar Identify, need to implement this somewhere

Local $result = DllCall($hFuncLib, "str", "searchIdentifyTroop", "ptr", $hHBitmap2)
    ConsoleWrite("result : "&$result[0])

Return :
Barbarian|14-26|0#Archer|87-30|75#WallBreaker|303-34|1#Wizard|377-35|1#Minion|451-31|1

3 elements per troops type, first split at "#" for trooptype, then split at "|" for the 3 elements per trooptype, last split at "-" for coordinates

3rd element will be 0 if ocr failed to read the quantity

#ce

Func IdentifyTroopKind($SlotPos = 0)
	; capture troopbar
	Local $x1 = 0, $y1 = 550, $x2 = $DEFAULT_WIDTH, $y2 = $DEFAULT_HEIGHT - 60, $SlotComp
	_CaptureRegion($x1, $y1, $x2, $y2)

            Switch $SlotPos
                Case 2 To 3
                    $SlotComp = 1
                Case 4 to 6
                    $SlotComp = 2
				Case 7 to 10
                    $SlotComp = 3
	    		Case Else
					$SlotComp = 0
            EndSwitch

	If _ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos), 607 - $y1), Hex(0x80D154, 6), 40) OR _
		_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos), 607 - $y1), Hex(0x8BE25B, 6), 40) Then Return $eGobl		;Check if slot is Goblin   -- DONE
	If _ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos), 607 - $y1), Hex(0xFFD098, 6), 40) OR _
		_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos), 607 - $y1), Hex(0xFFD8A4, 6), 40) Then Return $eGiant		;Check if slot is Giant   -- DONE

	; Make from SLOT 0 (68,57)  (68,100)  (53,75)  (83,75)
	For $j=-2 to 2
		If ( _ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$j, 607 - $y1), Hex(0xFFBF23, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$j, 650 - $y1), Hex(0xE5938C, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)-15+$j, 625 - $y1), Hex(0xA58E83, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)+15+$j, 625 - $y1), Hex(0xFFD6C6, 6), 40)     _
																														) Then Return $eBarb
		Next
	; Make from SLOT 1 (140,57)  (140,100)  (125,75)  (155,75)
	For $j=-2 to 2
		If ( _ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$j, 607 - $y1), Hex(0xFB58CB, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$j, 650 - $y1), Hex(0x313900, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)-15+$j, 625 - $y1), Hex(0x702548, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)+15+$j, 625 - $y1), Hex(0xE03C61, 6), 40)     _
																														) Then Return $eArch
	Next
	; Make from SLOT 2 (213,57)  (213,100)  (198,75)  (228,75)
	For $j=-2 to 2
		If ( _ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$j, 607 - $y1), Hex(0x32241A, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$j, 650 - $y1), Hex(0x322B25, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)-15+$j, 625 - $y1), Hex(0x191A15, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)+15+$j, 625 - $y1), Hex(0x0B6EA1, 6), 40)     _
																														) Then Return $eHogs
	Next
	; Make from SLOT 3 (285,57)  (285,100)  (270,75)  (300,75)
	For $j=-2 to 2
		If ( _ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$j, 607 - $y1), Hex(0x92360A, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$j, 650 - $y1), Hex(0xB56A5F, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)-15+$j, 625 - $y1), Hex(0xA03800, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)+15+$j, 625 - $y1), Hex(0x727A74, 6), 40)     _
																														) Then Return $eValk
	Next
	; Make from SLOT 4 (358,57)  (358,100)  (343,75)  (373,75)
	For $j=-2 to 2
		If ( _ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$j, 607 - $y1), Hex(0xDAC0A2, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$j, 650 - $y1), Hex(0x83705F, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)-15+$j, 625 - $y1), Hex(0x691941, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)+15+$j, 625 - $y1), Hex(0x6E6352, 6), 40)     _
																														) Then Return $eGole
	Next
	; Make from SLOT 5 (430,57)  (430,100)  (415,75)  (445,75)
	For $j=-2 to 2
		If ( _ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$j, 607 - $y1), Hex(0x7674B6, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$j, 650 - $y1), Hex(0x49487E, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)-15+$j, 625 - $y1), Hex(0x302D58, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)+15+$j, 625 - $y1), Hex(0xEC167B, 6), 40)     _
																														) Then Return $eWitc
	Next
	; Make from SLOT 6 (502,57)  (502,100)  (487,75)  (517,75)
	For $j=-2 to 2
		If ( _ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$j, 607 - $y1), Hex(0x806D60, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$j, 650 - $y1), Hex(0x283826, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)-15+$j, 625 - $y1), Hex(0x807567, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)+15+$j, 625 - $y1), Hex(0x515049, 6), 40)     _
																														) Then Return $eLava
	Next
	; Make from SLOT 7 (575,57)  (575,100)  (560,75)  (590,75)
	For $j=-2 to 2
		If ( _ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$j, 607 - $y1), Hex(0xB64F3E, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$j, 650 - $y1), Hex(0xFDBCAA, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)-15+$j, 625 - $y1), Hex(0xE0C058, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)+15+$j, 625 - $y1), Hex(0xB46262, 6), 40)     _
																														) Then Return $eKing
	Next
	; Make from SLOT 8 (647,57)  (647,100)  (632,75)  (662,75)
	For $j=-2 to 2
		If ( _ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$j, 607 - $y1), Hex(0xF7BDBD, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$j, 650 - $y1), Hex(0x0428F0, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)-15+$j, 625 - $y1), Hex(0x9CE2F7, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)+15+$j, 625 - $y1), Hex(0xE7F8FF, 6), 40)     _
																														) Then Return $eLSpell
	Next
	; Make from SLOT 9 (719,57)  (719,100)  (704,75)  (734,75)
	For $j=-2 to 2
		If ( _ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$j, 607 - $y1), Hex(0xE8B67B, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$j, 650 - $y1), Hex(0xC08832, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)-15+$j, 625 - $y1), Hex(0x806C54, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)+15+$j, 625 - $y1), Hex(0xE2E1CB, 6), 40)     _
																														) Then Return $eHSpell
	Next
	; Make from SLOT 10 (791,57)  (791,100)  (776,75)  (806,75)
	For $j=-2 to 2
		If ( _ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$j, 607 - $y1), Hex(0xC8F3FF, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$j, 650 - $y1), Hex(0x14AAD4, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)-15+$j, 625 - $y1), Hex(0x4CAED9, 6), 40) AND _
			_ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)+15+$j, 625 - $y1), Hex(0xD8F8F8, 6), 40)     _
                                                                                                                     ) Then Return $eFSpell
	Next
	Return -1
EndFunc   ;==>IdentifyTroopKind


Func IdentifyTroopKindCreate($SlotPos = 0)
	; capture troopbar
	Local $x1 = 0, $y1 = 550, $x2 = $DEFAULT_WIDTH, $y2 = $DEFAULT_HEIGHT - 60, $SlotComp
	_CaptureRegion($x1, $y1, $x2, $y2)
            Switch $SlotPos
                Case 2 To 3
                    $SlotComp = 1
                Case 4 to 6
                    $SlotComp = 2
				Case 7 to 10
                    $SlotComp = 3
				Case Else
					$SlotComp = 0
            EndSwitch

		Local $color1 =  _GetPixelColor(68 + $SlotComp + (72 * $SlotPos)  , 607 - $y1)
		Local $color2 =  _GetPixelColor(68 + $SlotComp + (72 * $SlotPos)  , 650 - $y1)
		Local $color3 =  _GetPixelColor(68 + $SlotComp + (72 * $SlotPos)-15, 625 - $y1)
		Local $color4 =  _GetPixelColor(68 + $SlotComp + (72 * $SlotPos)+15, 625 - $y1)

		SetLog (";Make from SLOT " & $SlotPos & _
				" (" & 68 + $SlotComp + (72 * $SlotPos)    & "," & 607 - $y1 & ") "  _
				& " (" & 68 + $SlotComp + (72 * $SlotPos)    & "," & 650 - $y1 & ") "  _
				& " (" & 68 + $SlotComp + (72 * $SlotPos)-15 & "," & 625 - $y1 & ") "  _
				& " (" & 68 + $SlotComp + (72 * $SlotPos)+15 & "," & 625 - $y1 & ") "      )
		SetLog ("For $j= -2 to 2" )
		SetLog ("   If ( _ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$y, 607 - $y1), Hex(0x" & $color1 & ", 6), 40) AND _ " )
		SetLog ("        _ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)   +$y, 650 - $y1), Hex(0x" & $color2 & ", 6), 40) AND _ " )
		SetLog ("        _ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)-15+$y, 625 - $y1), Hex(0x" & $color3 & ", 6), 40) AND _ " )
		SetLog ("        _ColorCheck(_GetPixelColor(68 + $SlotComp + (72 * $SlotPos)+15+$y, 625 - $y1), Hex(0x" & $color4 & ", 6), 40)     _ " )
		SetLog ("                                                                                                                      ) Then Return $eXXXXX " )
		SetLog ("Next" )

EndFunc  ;==>IdentifyTroopKindCreate