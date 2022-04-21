#include-once

Local Const $iIconPath = @ScriptDir & "\Icons\"

Func _OnButtonClickSpam()
  ; Get spammer index
  Local $iSpamIndex = GUICtrlRead(@GUI_CtrlId - 2)

  ; Get spammer state
  Local $bSpammer = ($g_aSpammers[$iSpamIndex][$g_eSpamPID] <> "")

  ; Start or Stop spammer
  If $bSpammer = False Then
    _SpamStart($iSpamIndex)
  Else
    _SpamStop($iSpamIndex)
  EndIf
EndFunc   ;==>_OnButtonClick

Func _OnIconClick1()
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

Func _OnIconClick2()
   ; Get spammer index
   Local $iSpamIndex = GUICtrlRead(@GUI_CtrlId - 8)
   Local $sFileOpenDialog = FileOpenDialog("Pick an icon", $iIconPath, "JPEG (*.jpg;*.jpeg;*.jpe;*.jfif)")
   If $sFileOpenDialog <> "" Then
	  If not @error Then
		 If StringInStr($sFileOpenDialog, $iIconPath) <> 0 Then
			Local $iFilename = StringReplace($sFileOpenDialog, $iIconPath, "")
			GUICtrlSetImage($g_aSpammers[$iSpamIndex][$g_eIcon2], $sFileOpenDialog)
			$g_aSpammers[$iSpamIndex][$g_eIcon2Path] = $iFilename
		 Else
			MsgBox(0, "Invalid path!", "File has to be located in Icons folder!")
		 EndIf
	  EndIf
   EndIf
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
  Local $iIcon2File = $g_aSpammers[$iSpamIndex][$g_eIcon2Path]
  Local $iIcon2 = $g_aSpammers[$iSpamIndex][$g_eIcon2]

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
    Case $sFKey = " " And $sSkill = " "
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
  If $iIcon1File = "none.jpg" Then
	 GUICtrlSetState($iIcon1, $GUI_HIDE)
  EndIf
  If $iIcon2File = "none.jpg" Then
	 GUICtrlSetState($iIcon2, $GUI_HIDE)
  EndIf
  GUICtrlSetState($iIcon1, $GUI_DISABLE)
  GUICtrlSetState($iIcon2, $GUI_DISABLE)

  GUICtrlSetBkColor($iButtonCtrlId, $COLOR_GREEN)

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
  Local $iIcon2File = $g_aSpammers[$iSpamIndex][$g_eIcon2Path]
  Local $iIcon2 = $g_aSpammers[$iSpamIndex][$g_eIcon2]

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
  If $iIcon1File = "none.jpg" Then
	 GUICtrlSetState($iIcon1, $GUI_SHOW)
  EndIf
  If $iIcon2File = "none.jpg" Then
	 GUICtrlSetState($iIcon2, $GUI_SHOW)
  EndIf
  GUICtrlSetState($iIcon1, $GUI_ENABLE)
  GUICtrlSetState($iIcon2, $GUI_ENABLE)

  GUICtrlSetBkColor($iButtonCtrlId, $COLOR_DARK1)
EndFunc   ;==>_SpamStop
