#include-once

Local Const $iIconPath = @ScriptDir & "\Icons\"

Func _OnButtonClickSpam($index = -1)
   ; Get spammer index
   Local $iSpamIndex = 0
   If @NumParams = 1 Then
	  $iSpamIndex = $index
   Else
	  $iSpamIndex = GUICtrlRead(@GUI_CtrlId - 2)
   EndIf

  ; Get spammer state
   Local $bSpammer = ($g_aSpammers[$iSpamIndex][$g_eSpamPID] <> "")

  ; Start or Stop spammer
   If $bSpammer = False Then
	  _SpamStart($iSpamIndex)
   Else
	  _SpamStop($iSpamIndex)
   EndIf
EndFunc   ;==>_OnButtonClick

Func _OnSpammerNameLabelClick()
   ; Get index
  Local $iIndex = GUICtrlRead(@GUI_CtrlId - 1) ; ID des Spammers
  Local $input = InputBox("Set name", "Set a new name for this spammer:", $g_aSpammers[$iIndex][$g_eLabelText], "", 250, 140)
  If (@error <> 1) Then ; if not canceled
    $g_aSpammers[$iIndex][$g_eLabelText] = $input
    GUICtrlSetData($g_aSpammers[$iIndex][$g_eLabelCtrl], $input)
  EndIf
EndFunc   ;==>_OnSpammerNameLabelClick

Func _OnSpammerIconClick()
   ; Get spammer index
   Local $iSpamIndex = GUICtrlRead(@GUI_CtrlId - 7)
   Local $sFileOpenDialog = FileOpenDialog("Pick a new icon", $iIconPath, "JPEG (*.jpg;*.jpeg;*.jpe;*.jfif)")
   If $sFileOpenDialog <> "" Then
	  If not @error Then
		 If StringInStr($sFileOpenDialog, $iIconPath) <> 0 Then
			Local $iFilename = StringReplace($sFileOpenDialog, $iIconPath, "") ; convert dir to filename
			GUICtrlSetImage($g_aSpammers[$iSpamIndex][$g_eIcon1], $sFileOpenDialog)
			$g_aSpammers[$iSpamIndex][$g_eIcon1Path] = $iFilename
		 Else
			MsgBox(0, "Invalid path!", "File has to be located in Icons folder!")
		 EndIf
	  EndIf
   EndIf
EndFunc

Func _OnButtonClickSpammerHotkey()
   ; Get spammer index
   Local $iSpamIndex = GUICtrlRead(@GUI_CtrlId - 10)
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
			   $g_aSpammers[$iSpamIndex][$g_eHotkey] = $hex
			   GUICtrlSetData($g_aSpammers[$iSpamIndex][$g_eHotkeyLabel], _HexToKey($hex))
			Else ; "-" -> remove this hotkey
			   $g_aSpammers[$iSpamIndex][$g_eHotkey] = "-"
			   GUICtrlSetData($g_aSpammers[$iSpamIndex][$g_eHotkeyLabel], "-")
			EndIf
			$pressed = True
			ExitLoop
		 EndIf
	  Next
   WEnd
   SplashOff()
EndFunc

Func _SpamStart($iSpamIndex)
  ; Get input controlID
  Local $iButtonCtrlId = $g_aSpammers[$iSpamIndex][$g_eSpamButton]
  Local $iWindowCtrlId = $g_aSpammers[$iSpamIndex][$g_eSpamWindow]
  Local $iIntervalCtrlId = $g_aSpammers[$iSpamIndex][$g_eSpamInterval]
  Local $iFKeyCtrlId = $g_aSpammers[$iSpamIndex][$g_eSpamFKey]
  Local $iSkillCtrlId = $g_aSpammers[$iSpamIndex][$g_eSpamSkill]
  Local $iDefColorCtrlId = $g_aSpammers[$iSpamIndex][$g_eDefColor]
  Local $iColorCtrlId = $g_aSpammers[$iSpamIndex][$g_eSpamColor]
  Local $iIcon1File = $g_aSpammers[$iSpamIndex][$g_eIcon1Path]
  Local $iIcon1 = $g_aSpammers[$iSpamIndex][$g_eIcon1]
  Local $iHotkeyBtnCtrlId = $g_aSpammers[$iSpamIndex][$g_eHotkeyButton]


  ; Get input data
  Local $sWindow = _getWindowNameFromCharacter(GUICtrlRead($iWindowCtrlId))
  Local $iInterval = GUICtrlRead($iIntervalCtrlId)
  Local $sFKey = GUICtrlRead($iFKeyCtrlId)
  Local $sSkill = GUICtrlRead($iSkillCtrlId)
  Local $sSpammerFile = @ScriptDir & "\Subfiles\Spammer.exe"

  ; Check if interval has value otherwise set inverval to 0
  If $iInterval = "" Then
    $iInterval = 0
    GUICtrlSetData($iIntervalCtrlId, $iInterval)
  EndIf

  ; Validate input data
  Select
    ; Check if spammer.exe file exists
    Case FileExists($sSpammerFile) = 0
      MsgBox($MB_TASKMODAL + $MB_ICONERROR, $sSpammerFile, "Windows cannot find " & @CRLF & "'" & $sSpammerFile & "'.")
      Return

    ; Check if window has been selected
    Case $sWindow = $g_sSelectWindow
      MsgBox($MB_TASKMODAL + $MB_ICONERROR, $g_sSelectWindow, "Select a Flyff window.")
      Return

    ; Check if window still exists
    Case WinExists($sWindow) = 0
      MsgBox($MB_TASKMODAL + $MB_ICONERROR, $sWindow, "Selected Flyff window doesn't exist.")
      Return

    ; Check if fkey or skill has been selected
    Case $sFKey = "-" And $sSkill = "-"
      MsgBox($MB_TASKMODAL + $MB_ICONERROR, "Validation Error", "Select atleast one F-Key or Skill Bar.")
      Return
  EndSelect

  ; Disable controls
  GUICtrlSetData($iButtonCtrlId, "Stop")
  GUICtrlSetState($iWindowCtrlId, $GUI_DISABLE)
  GUICtrlSetState($iIntervalCtrlId, $GUI_DISABLE)
  GUICtrlSetState($iFKeyCtrlId, $GUI_DISABLE)
  GUICtrlSetState($iSkillCtrlId, $GUI_DISABLE)
  GUICtrlSetState($iDefColorCtrlId, $GUI_HIDE)
  GUICtrlSetState($iColorCtrlId, $GUI_SHOW)
  GUICtrlSetState($iHotkeyBtnCtrlId, $GUI_DISABLE)
  If $iIcon1File = "none.jpg" Then
	 GUICtrlSetState($iIcon1, $GUI_HIDE)
  EndIf
  GUICtrlSetState($iIcon1, $GUI_DISABLE)

  GUICtrlSetBkColor($iButtonCtrlId, $COLOR_GREEN)
  ; play Beep
  If ($bSoundsEnabled = 1) Then
    SoundPlay(@ScriptDir & "\Sounds\" & $sSoundFileSpamStart, 0)
  EndIf

  ; Get main window PID
  Local $iMainPID = WinGetProcess($hMainGUI)

  ; Get flyff window handle
  Local $hWindow = WinGetHandle($sWindow)

  ; Run script with params: main window PID, flyff window handle, interval, fkey and skill bar
  Local $sParams = $iMainPID & ' "' & $hWindow & '" ' & $iInterval & ' "' & $sFKey & '" "' & $sSkill & '"'

  ; Save window title
  $g_aSpammers[$iSpamIndex][$g_eSpamWindowTitle] = $sWindow

  ; Save spammer.exe process PID
  $g_aSpammers[$iSpamIndex][$g_eSpamPID] = Run($sSpammerFile & ' ' & $sParams)
EndFunc   ;==>_SpamStart


Func _SpamStop($iSpamIndex)
  ; Get input controlID
  Local $iButtonCtrlId = $g_aSpammers[$iSpamIndex][$g_eSpamButton]
  Local $iWindowCtrlId = $g_aSpammers[$iSpamIndex][$g_eSpamWindow]
  Local $iIntervalCtrlId = $g_aSpammers[$iSpamIndex][$g_eSpamInterval]
  Local $iFKeyCtrlId = $g_aSpammers[$iSpamIndex][$g_eSpamFKey]
  Local $iSkillCtrlId = $g_aSpammers[$iSpamIndex][$g_eSpamSkill]
  Local $iDefColorCtrlId = $g_aSpammers[$iSpamIndex][$g_eDefColor]
  Local $iColorCtrlId = $g_aSpammers[$iSpamIndex][$g_eSpamColor]
  Local $iIcon1File = $g_aSpammers[$iSpamIndex][$g_eIcon1Path]
  Local $iIcon1 = $g_aSpammers[$iSpamIndex][$g_eIcon1]
  Local $iHotkeyBtnCtrlId = $g_aSpammers[$iSpamIndex][$g_eHotkeyButton]

  ; Clear window title
  $g_aSpammers[$iSpamIndex][$g_eSpamWindowTitle] = ""

  ; Stop spammer.exe process
  ProcessClose($g_aSpammers[$iSpamIndex][$g_eSpamPID])
  $g_aSpammers[$iSpamIndex][$g_eSpamPID] = ""

  ; Enable controls
  GUICtrlSetData($iButtonCtrlId, "Start")
  GUICtrlSetState($iWindowCtrlId, $GUI_ENABLE)
  GUICtrlSetState($iIntervalCtrlId, $GUI_ENABLE)
  GUICtrlSetState($iFKeyCtrlId, $GUI_ENABLE)
  GUICtrlSetState($iSkillCtrlId, $GUI_ENABLE)
  GUICtrlSetState($iColorCtrlId, $GUI_HIDE)
  GUICtrlSetState($iDefColorCtrlId, $GUI_SHOW)
  GUICtrlSetState($iHotkeyBtnCtrlId, $GUI_ENABLE)
  If $iIcon1File = "none.jpg" Then
	 GUICtrlSetState($iIcon1, $GUI_SHOW)
  EndIf
  GUICtrlSetState($iIcon1, $GUI_ENABLE)

  GUICtrlSetBkColor($iButtonCtrlId, $COLOR_DARK1)
  ; play Beep
  If ($bSoundsEnabled = 1) Then
    SoundPlay(@ScriptDir & "\Sounds\" & $sSoundFileSpamStop, 0)
  EndIf
EndFunc   ;==>_SpamStop
