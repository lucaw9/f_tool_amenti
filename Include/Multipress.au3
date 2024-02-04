#include-once


Func _OnButtonClickMultiPress($index = -1)
  ; Get presser index
   Local $iPressIndex = 0
   If @NumParams = 1 Then
	  $iPressIndex = $index
   Else
	  $iPressIndex = GUICtrlRead(@GUI_CtrlId - 2)
   EndIf
  ; Press

  _MultiPress($iPressIndex)
EndFunc   ;==>_OnButtonClick

Func _MultiPressButtonFlash($iPressIndex)
  ; Press
  Local $iButtonCtrlId = $g_aMultiPressers[$iPressIndex][$g_eSpamButton]
  GUICtrlSetBkColor($iButtonCtrlId, $COLOR_GREEN)
  ; play Beep
  If ($bSoundsEnabled) Then
     SoundPlay(@ScriptDir & "\Sounds\" & $sSoundFilePresser, 0)
  EndIf
  Sleep(100)
  GUICtrlSetBkColor($iButtonCtrlId, $COLOR_DARK1)
EndFunc   ;==>_MultiPressButtonFlash

Local $text = "Specify a comma-separated list containing skillbar (- or 1-8), F-key (F1-9 or z), character name, and skillbar to return to (- or 1-8)." & @CRLF & "Example 1: 1,F2,Test,2. Example 2: -,z,Test,-"

Func _OnButtonClickAdd()
  ; Get index
  Local $iIndex = GUICtrlRead(@GUI_CtrlId - 5) ; ID des MultiPressers
  Local $input = InputBox("Add action", $text, "", "", 300, 180)
  $g_aMultiPressers[$iIndex][4] = $g_aMultiPressers[$iIndex][4] & "|" & $input
  _UpdateContent($iIndex)
EndFunc   ;==>_OnButtonClickAdd

Func _OnButtonClickDelete()
  ; Get index
  Local $iIndex = GUICtrlRead(@GUI_CtrlId - 7)
  Local $iSelected = GUICtrlRead($g_aMultiPressers[$iIndex][3])
  if $iSelected <> "" Then
	  $g_aMultiPressers[$iIndex][4] = StringReplace($g_aMultiPressers[$iIndex][4], $iSelected, "", 1, 1)
	  _UpdateContent($iIndex)
  EndIf
EndFunc   ;==>_OnButtonClickDelete

Func _OnButtonClickEdit()
  ; Get index
  Local $iIndex = GUICtrlRead(@GUI_CtrlId - 6)
  Local $iSelected = GUICtrlRead($g_aMultiPressers[$iIndex][3])
  if $iSelected <> "" Then
	  Local $input = InputBox("Edit action", $text, $iSelected, "", 300, 180)
	  if $input <> "" Then
		 $g_aMultiPressers[$iIndex][4] = StringReplace($g_aMultiPressers[$iIndex][4], $iSelected, $input, 1, 1)
		 _UpdateContent($iIndex)
	  EndIf
   EndIf
EndFunc   ;==>_OnButtonClickEdit

Func _OnButtonClickPresserHotkey()
   ; Get presser index
   Local $iIndex = GUICtrlRead(@GUI_CtrlId - 10)
   SplashTextOn("Edit Hotkey", "Press a key." & @CRLF & "Your base + this key will be the combination to activate this spammer." & @CRLF & "Press - to remove this hotkey." & @CRLF & "" & @CRLF & "Additional info:" & @CRLF & "Some keys might not work." & @CRLF & "When setting the same hotkey for multiple spammers or pressers, only the first one will be activated.", 600, 150, WinGetPos($hMainGUI)[0], WinGetPos($hMainGUI)[1]+100, 0, "", 8)
   Local $pressed = False
   ; loop until key is pressed
   While Not $pressed
	  ; check all possible keys
	  For $h = 8 To 254
		 Local $hex = Hex($h)
		 If _IsPressed($hex, $hDLL) Then
			; if not "-" -> use this hotkey
			If $hex <> Hex(189) Then
			   $g_aMultiPressers[$iIndex][10] = $hex
			   GUICtrlSetData($g_aMultiPressers[$iIndex][11], _HexToKey($hex))
			Else ; "-" -> remove this hotkey
			   $g_aMultiPressers[$iIndex][10] = "-"
			   GUICtrlSetData($g_aMultiPressers[$iIndex][11], "-")
			EndIf
			$pressed = True
			ExitLoop
		 EndIf
	  Next
   WEnd
   SplashOff()
EndFunc

Func _OnPresserIconClick()
   ; Get spammer index
   Local $iIndex = GUICtrlRead(@GUI_CtrlId - 11)
   Local $sFileOpenDialog = FileOpenDialog("Pick a new icon", $iIconPath, "JPEG (*.jpg;*.jpeg;*.jpe;*.jfif)")
   If $sFileOpenDialog <> "" Then
	  If not @error Then
		 If StringInStr($sFileOpenDialog, $iIconPath) <> 0 Then
			Local $iFilename = StringReplace($sFileOpenDialog, $iIconPath, "") ; convert dir to filename
			GUICtrlSetImage($g_aMultiPressers[$iIndex][12], $sFileOpenDialog)
			$g_aMultiPressers[$iIndex][13] = $iFilename
		 Else
			MsgBox(0, "Invalid path!", "File has to be located in Icons folder!")
		 EndIf
	  EndIf
   EndIf
EndFunc

Func _UpdateContent($iIndex)
  Local $iList = $g_aMultiPressers[$iIndex][3]
  Local $iContent = $g_aMultiPressers[$iIndex][4]
  Local $contentArray = StringSplit($iContent, "", 2) ; Flag for no count as first element
  Local $iNewContent = ""
  Local $iPrevSeparator = True
  For $i = 0 To UBound($contentArray) - 1
	 If ($contentArray[$i] <> "|") Then
		$iNewContent = $iNewContent & $contentArray[$i]
		$iPrevSeparator = False
	 Else
		If ($iPrevSeparator <> True) and ($i <> UBound($contentArray) - 1) Then
		   $iNewContent = $iNewContent & $contentArray[$i]
		   $iPrevSeparator = True
	    EndIf
	 EndIf
  Next
  $g_aMultiPressers[$iIndex][4] = $iNewContent
  GUICtrlSetData($iList, "")
  GUICtrlSetData($iList, $iNewContent)
EndFunc   ;==>_UpdateContent

Func _OnPresserNameLabelClick()
   ; Get index
  Local $iIndex = GUICtrlRead(@GUI_CtrlId - 1) ; ID des MultiPressers
  Local $input = InputBox("Set name", "Set a new name for this presser:", $g_aMultiPressers[$iIndex][8], "", 250, 140)
  If (@error <> 1) Then ; if not canceled
    $g_aMultiPressers[$iIndex][8] = $input
    GUICtrlSetData($g_aMultiPressers[$iIndex][9], $input)
  EndIf
EndFunc   ;==>_OnPresserNameLabelClick

Func _MultiPress($iIndex)
  ; Get input data
  Local $sContent = $g_aMultiPressers[$iIndex][4]
  Local $sPresserFile = @ScriptDir & "\Subfiles\Presser.exe"

  ; Check if Presser.exe file exists
  If FileExists($sPresserFile) = 0 Then
      MsgBox($MB_TASKMODAL + $MB_ICONERROR, $sPresserFile, "Windows cannot find " & @CRLF & "'" & $sPresserFile & "'.")
      Return
  EndIf

  ; Get main window PID
  Local $iMainPID = WinGetProcess($hMainGUI)

  Local $aContent = StringSplit($sContent, "|", 2)
  For $i = 0 To UBound($aContent) - 1
	  Local $list = StringSplit($aContent[$i], ",", 2)
	  If (UBound($list) <> 4) Or (StringLen($list[2]) < 4) Or (StringLen($list[0]) > 1) Or (StringLen($list[1]) > 2) Or (StringLen($list[3]) > 1) Then
		 MsgBox($MB_TASKMODAL + $MB_ICONERROR, "Validation Error", "Invalid Input for Presser.")
		 Return
	  EndIf
	  $sWindow = _getWindowNameFromCharacter($list[2])
	  $sSkill = $list[0]
	  $sFKey = $list[1]
	  $sReturnSkill = $list[3]

	  ; Check if window still exists
	  If WinExists($sWindow) <> 0 Then
		 If $sFKey = "" And $sSkill = "" Then
			MsgBox($MB_TASKMODAL + $MB_ICONERROR, "Validation Error", "Select Key or Skill Bar for " & $sWindow & ".")
			Return
		 EndIf
		 ; Get flyff window handle
		 Local $hWindow = WinGetHandle($sWindow)
		 ; Run script with params: main window PID, flyff window handle, fkey and skill bar
		 Local $sParams = $iMainPID & ' "' & $hWindow & '" "' & $sFKey & '" "' & $sSkill & '" "' & $sReturnSkill & '"'
		 Run($sPresserFile & ' ' & $sParams)
	  EndIf
   Next

  ; flash button
  _MultiPressButtonFlash($iIndex)

EndFunc   ;==>_MultiPress