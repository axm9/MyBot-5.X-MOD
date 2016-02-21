Func OpenGUIMilk()
	GUIMilk()
	applyMilkingConfig()
	GUISetState(@SW_SHOW, $hMilkGUI)
	GUISetState(@SW_DISABLE, $frmBot)
EndFunc

Func SaveMilkingConfig()
	; 1 Elixir Collectors Minimum Level
	Local $TempMilkFarmElixirParam = ""
	For $i = 0 to 8
	   $TempMilkFarmElixirParam &= _GUICtrlComboBox_GetCurSel(  Eval("cmbMilkLvl"&$i+4) ) - 1  & "|"
    Next
    $MilkFarmElixirParam = StringSplit(StringLeft($TempMilkFarmElixirParam,StringLen($TempMilkFarmElixirParam) - 1 ),"|",2)

	; 2. If Elixir Collectors Found, Then
	If GUICtrlRead($chkAtkElixirExtractors) = $GUI_CHECKED Then
	   $MilkFarmLocateElixir = 1
    Else
	   $MilkFarmLocateElixir = 0
    EndIf

	If GUICtrlRead($chkAtkGoldMines) = $GUI_CHECKED Then
	   $MilkFarmLocateMine = 1
    Else
	   $MilkFarmLocateMine = 0
    EndIf
	$MilkFarmMineParam = _GUICtrlComboBox_GetCurSel($cmbAtkGoldMinesLevel) + 1

	If GUICtrlRead($chkAtkDarkDrills) = $GUI_CHECKED Then
	   $MilkFarmLocateDrill = 1
    Else
	   $MilkFarmLocateDrill = 0
    EndIf
	$MilkFarmDrillParam = _GUICtrlComboBox_GetCurSel($cmbAtkDarkDrillsLevel) + 1

	; 3. Only Attack If
	$MilkFarmResMaxTilesFromBorder = _GUICtrlComboBox_GetCurSel($cmbRedlineResDistance)

	If GUICtrlRead($chkAttackMinesifGold) = $GUI_CHECKED Then
	   $MilkFarmAttackGoldMines = 1
    Else
	   $MilkFarmAttackGoldMines = 0
    EndIf

	If GUICtrlRead($chkAttackMinesifElixir) = $GUI_CHECKED Then
	   $MilkFarmAttackElixirExtractors = 1
    Else
	   $MilkFarmAttackElixirExtractors = 0
    EndIf

	If GUICtrlRead($chkAttackMinesifDarkElixir) = $GUI_CHECKED Then
	   $MilkFarmAttackDarkDrills = 1
    Else
	   $MilkFarmAttackDarkDrills = 0
    EndIf

	$MilkFarmLimitGold = GUICtrlRead($txtAttackMinesIfGold)
	$MilkFarmLimitElixir = GUICtrlRead($txtAttackMinesifElixir)
	$MilkFarmLimitDark = GUICtrlRead($txtAttackMinesifDarkElixir)

	; 4 Troops to Use For Each Resource
	$MilkFarmTroopForWaveMin = GUICtrlRead($txtLowerXWave)
	$MilkFarmTroopForWaveMax = GUICtrlRead($txtUpperXWave)
	$MilkFarmTroopMaxWaves = GUICtrlRead($txtMaxWaves)
	$MilkFarmDelayFromWavesMin = GUICtrlRead($txtLowerDelayWaves)
	$MilkFarmDelayFromWavesMax = GUICtrlRead($txtUpperDelayWaves)

	If $DevMode = 1 Then

	   If GUICtrlRead($chkMilkingDebugIMG) = $GUI_CHECKED Then
		  $debugresourcesoffset = 1
	   Else
		  $debugresourcesoffset = 0
	   EndIf

	   If GUICtrlRead($chkMilkingDebugFullSearch) = $GUI_CHECKED Then
		  $continuesearchelixirdebug = 1
	   Else
		  $continuesearchelixirdebug = 0
	   EndIf
    EndIf
	GUIDelete($hMilkGUI)
	GUISetState(@SW_ENABLE, $frmBot)
EndFunc

Func chkAtkGoldMines()
	If GUICtrlRead($chkAtkGoldMines) = $GUI_CHECKED Then
		GUICtrlSetState($cmbAtkGoldMinesLevel, $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbAtkGoldMinesLevel, $GUI_DISABLE)
	EndIf
EndFunc

Func chkAtkDarkDrills()
	If GUICtrlRead($chkAtkDarkDrills) = $GUI_CHECKED Then
		GUICtrlSetState($cmbAtkDarkDrillsLevel, $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbAtkDarkDrillsLevel, $GUI_DISABLE)
	EndIf
EndFunc

Func chkAttackMinesifGold()
	If GUICtrlRead($chkattackminesifgold) = $GUI_CHECKED Then
		guictrlsetstate($txtAttackMinesIfGold, $GUI_ENABLE)
	Else
		guictrlsetstate($txtAttackMinesIfGold, $GUI_DISABLE)
	EndIf
EndFunc

Func chkAttackMinesifelixir()
	If GUICtrlRead($chkattackminesifelixir) = $GUI_CHECKED Then
		guictrlsetstate($txtAttackMinesIfelixir, $GUI_ENABLE)
	Else
		guictrlsetstate($txtAttackMinesIfelixir, $GUI_DISABLE)
	EndIf
EndFunc

Func chkAttackMinesifdarkElixir()
	If GUICtrlRead($chkattackminesifdarkElixir) = $GUI_CHECKED Then
		guictrlsetstate($txtAttackMinesIfdarkElixir, $GUI_ENABLE)
	Else
		guictrlsetstate($txtAttackMinesIfdarkElixir, $GUI_DISABLE)
	EndIf
EndFunc

Func applyMilkingConfig()
	; 1. elixir Collectors Minimum Level
	If Ubound( $MilkFarmElixirParam) = 9 Then
		For $i = 0 to Ubound($MilkFarmElixirParam) - 1
			_GUICtrlComboBox_SetCurSel(Eval("cmbMilkLvl" & $i + 4), $MilkFarmElixirParam[$i] + 1)
		Next
	Else
		For $i = 0 to 9 - 1
			_GUICtrlComboBox_SetCurSel(Eval("cmbMilkLvl" & $i + 4), 0)
		Next
	EndIf
	
	; 2 If Elixir Collectors Found, Then
	If $MilkFarmLocateElixir = 1 Then
		GUICtrlSetState($chkAtkElixirExtractors, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkAtkElixirExtractors, $GUI_UNCHECKED)
	EndIf
	
	If $MilkFarmLocateMine = 1 Then
		GUICtrlSetState($chkAtkGoldMines, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkAtkGoldMines, $GUI_UNCHECKED)
	EndIf
	
	_GUICtrlComboBox_SetCurSel($cmbAtkGoldMinesLevel, $MilkFarmMineParam - 1)
	
	If $MilkFarmLocateDrill = 1 Then
		GUICtrlSetState($chkAtkDarkDrills, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkAtkDarkDrills, $GUI_UNCHECKED)
	EndIf
	
	_GUICtrlComboBox_SetCurSel($cmbAtkDarkDrillsLevel, $MilkFarmAttackDarkDrills - 1)
	
	; 3 Only attack If
	_GUICtrlComboBox_SetCurSel($cmbRedlineResDistance, $MilkFarmResMaxTilesFromBorder)
	
	If $MilkFarmAttackElixirExtractors = 1 Then
		GUICtrlSetState($chkAttackMinesifElixir, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkAttackMinesifElixir, $GUI_UNCHECKED)
	EndIf
	If $MilkFarmAttackGoldMines = 1 Then
		GUICtrlSetState($chkAttackMinesifGold, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkAttackMinesifGold, $GUI_UNCHECKED)
	EndIf
	If $MilkFarmAttackDarkDrills = 1 Then
		GUICtrlSetState($chkAttackMinesifDarkElixir, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkAttackMinesifDarkElixir, $GUI_UNCHECKED)
	EndIf
	GUICtrlSetData($txtAttackMinesIfGold, $MilkFarmLimitGold)
	GUICtrlSetData($txtAttackMinesifElixir, $MilkFarmLimitElixir)
	GUICtrlSetData($txtAttackMinesifDarkElixir, $MilkFarmLimitDark)
	chkAttackMinesifGold()
	chkAttackMinesifelixir()
	chkAttackMinesifdarkElixir()

	GUICtrlSetData($txtLowerXWave, $MilkFarmTroopForWaveMin)
	GUICtrlSetData($txtUpperXWave, $MilkFarmTroopForWaveMax)
	GUICtrlSetData($txtMaxWaves, $MilkFarmTroopMaxWaves)
	GUICtrlSetData($txtLowerDelayWaves, $MilkFarmDelayFromWavesMin)
	GUICtrlSetData($txtUpperDelayWaves, $MilkFarmDelayFromWavesMax)

	If $DevMode = 1 Then
		GUICtrlSetState($grpMilkingDebug, $GUI_SHOW)
		GUICtrlSetState($chkMilkingDebugIMG, $GUI_SHOW)
		GUICtrlSetState($chkMilkingDebugFullSearch, $GUI_SHOW)
	
		If $debugresourcesoffset = 1 Then
			GUICtrlSetState($chkMilkingDebugIMG, $GUI_CHECKED)
		Else
			GUICtrlSetState($chkMilkingDebugIMG, $GUI_UNCHECKED)
		EndIf
	
		If $continuesearchelixirdebug = 1 Then
			GUICtrlSetState($chkMilkingDebugFullSearch, $GUI_CHECKED)
		Else
			GUICtrlSetState($chkMilkingDebugFullSearch, $GUI_UNCHECKED)
		EndIf
    EndIf
EndFunc

Func OpenGUIMilk2()
	GUIMilk()
	applyMilkingConfig()
	GUISetState(@SW_SHOW, $hMilkGUI)
	GUISetState(@SW_DISABLE, $frmBot)
EndFunc

Func CloseGUIMilk2()
	$gui3open = 0
	SaveMilkingConfig()
	GUIDelete($hMilkGUI)
	GUISetState(@SW_ENABLE, $frmBot)
	WinActivate($frmBot)
EndFunc