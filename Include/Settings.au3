#include-once

Local Const $sFilePath = @ScriptDir & "\Settings.ini"

Func _IniSave()
   Local $sSection = ""
   For $i = 0 To UBound($g_aSpammers) - 1
	  $sSection = "Spammer" & $i + 1
	  ; Save all settings
	  IniWrite($sFilePath, $sSection, "WindowTitle", GUICtrlRead($g_aSpammers[$i][$g_eSpamWindow]))
	  IniWrite($sFilePath, $sSection, "Interval", GUICtrlRead($g_aSpammers[$i][$g_eSpamInterval]))
	  IniWrite($sFilePath, $sSection, "Icon1", $g_aSpammers[$i][$g_eIcon1Path])
	  IniWrite($sFilePath, $sSection, "Hotkey", $g_aSpammers[$i][$g_eHotkey])
	  IniWrite($sFilePath, $sSection, "FKey", GUICtrlRead($g_aSpammers[$i][$g_eSpamFKey]))
	  IniWrite($sFilePath, $sSection, "Skill", GUICtrlRead($g_aSpammers[$i][$g_eSpamSkill]))
	  IniWrite($sFilePath, $sSection, "Name", $g_aSpammers[$i][$g_eLabelText])
   Next

   Local $mSection = ""
   For $k = 0 To UBound($g_aMultiPressers) - 1
	  $mSection = "MultiPresser" & $k + 1

	  ; Save all settings
	  IniWrite($sFilePath, $mSection, "Content", $g_aMultiPressers[$k][4])
	  IniWrite($sFilePath, $mSection, "Name", $g_aMultiPressers[$k][8])
	  IniWrite($sFilePath, $mSection, "Hotkey", $g_aMultiPressers[$k][10])
	  IniWrite($sFilePath, $mSection, "Icon", $g_aMultiPressers[$k][13])
   Next
EndFunc ;==>_IniSave

Func _ReadWinPosition(ByRef $iWinLeft, ByRef $iWinTop)
   $iWinLeft = IniRead($sFilePath, "General", "Left", -1)
   $iWinTop = IniRead($sFilePath, "General", "Top", -1)
EndFunc

Func _ReadOrientation(ByRef $iOrientation)
   $iOrientation = IniRead($sFilePath, "General", "Orientation", "vertical")
EndFunc

Func _ReadRows(ByRef $iRows)
   $iRows = IniRead($sFilePath, "General", "Rows", 1)
EndFunc

Func _ReadKeyLoopTime(ByRef $iTime)
   $iTime = IniRead($sFilePath, "General", "KeyLoopTime", 100)
EndFunc

Func _ReadHotkeyBase(ByRef $iHotkeyBaseSpam, ByRef $iHotkeyBasePress)
   $iHotkeyBaseSpam = IniRead($sFilePath, "General", "HotkeyBaseSpammer", "000000A0")
   $iHotkeyBasePress = IniRead($sFilePath, "General", "HotkeyBasePresser", "000000A0")
EndFunc

Func _ReadSounds(ByRef $SoundsEnabled, ByRef $SoundFileSpamStart, ByRef $SoundFileSpamStop, ByRef $SoundFilePresser)
   $SoundsEnabled = IniRead($sFilePath, "General", "SoundsEnabled", 0)
   $SoundFileSpamStart = IniRead($sFilePath, "General", "SoundSpamStart", "750hz.mp3")
   $SoundFileSpamStop = IniRead($sFilePath, "General", "SoundSpamStop", "350hz.mp3")
   $SoundFilePresser = IniRead($sFilePath, "General", "SoundPresser", "500hz.mp3")
EndFunc

Func _getTabArray()
   Local $tab_count = IniRead($sFilePath, "General", "Tabs", 2)
   Local $array[$tab_count][3]
   For $i = 1 To $tab_count
	  $array[$i-1][0] = IniRead($sFilePath, "General", "tab" & $i, "Tab" & $i)
	  $array[$i-1][1] = IniRead($sFilePath, "General", "tab" & $i & "spammers", 2)
	  $array[$i-1][2] = IniRead($sFilePath, "General", "tab" & $i & "pressers", 2)
   Next
   Return $array
EndFunc

Func _SaveWinPosition(ByRef $iWinLeft, ByRef $iWinTop)
   IniWrite($sFilePath, "General", "Left", $iWinLeft)
   IniWrite($sFilePath, "General", "Top", $iWinTop)
EndFunc

Func _IniLoad()
  Local $sSection = "", $sWindowTitle, $iInterval, $iIcon1, $iIcon2, $sFKey, $sSkill
  Local $mSection = "", $mWindowTitle, $mDescription, $mFKey, $mSkill


   For $i = 0 to UBound($g_aSpammers) - 1
	  $sSection = "Spammer" & $i + 1

	  ; Set window title
	  $sWindowTitle = IniRead($sFilePath, $sSection, "WindowTitle", $g_sSelectWindow)
	  If $sWindowTitle = "" Then
		 $sWindowTitle = $g_sSelectWindow
	  EndIf
	  GUICtrlSetData($g_aSpammers[$i][$g_eSpamWindow], $sWindowTitle, $sWindowTitle)

	  ; Set interval
	  $iInterval = Int(IniRead($sFilePath, $sSection, "Interval", "0"))
	  GUICtrlSetData($g_aSpammers[$i][$g_eSpamInterval], $iInterval)

	  ; Set icon1
	  $iIcon1 = IniRead($sFilePath, $sSection, "Icon1", "")
	  If $iIcon1 = "" Then
		 $iIcon1 = "none.jpg"
	  EndIf
	  GUICtrlSetImage($g_aSpammers[$i][$g_eIcon1], @ScriptDir & "\Icons\" & $iIcon1)
	  $g_aSpammers[$i][$g_eIcon1Path] = $iIcon1

	  ; Set Hotkey
	  $iHotkey = IniRead($sFilePath, $sSection, "Hotkey", "-")
	  GUICtrlSetData($g_aSpammers[$i][$g_eHotkeyLabel], HexToKey($iHotkey))
	  $g_aSpammers[$i][$g_eHotkey] = $iHotkey

	  ; Set fkey
	  $sFKey = IniRead($sFilePath, $sSection, "FKey", "-")
	  GUICtrlSetData($g_aSpammers[$i][$g_eSpamFKey], "F1|F2|F3|F4|F5|F6|F7|F8|F9", $sFKey)

	  ; Set skill
	  $sSkill = IniRead($sFilePath, $sSection, "Skill", "-")
	  GUICtrlSetData($g_aSpammers[$i][$g_eSpamSkill], "1|2|3|4|5|6|7|8", $sSkill)

	  ; Set name
	  $sName = IniRead($sFilePath, $sSection, "Name", "Spammer")
	  GUICtrlSetData($g_aSpammers[$i][$g_eLabelCtrl], $sName)
	  $g_aSpammers[$i][$g_eLabelText] = $sName
   Next

   For $k = 0 to UBound($g_aMultiPressers) - 1
	  $mSection = "MultiPresser" & $k + 1

	  ; Set Content
	  $mContent = IniRead($sFilePath, $mSection, "Content", "")
	  $g_aMultiPressers[$k][4] = $mContent
	  GUICtrlSetData($g_aMultiPressers[$k][3], $mContent)

	  ; Set name
	  $mName = IniRead($sFilePath, $mSection, "Name", "Presser")
	  GUICtrlSetData($g_aMultiPressers[$k][9], $mName)
	  $g_aMultiPressers[$k][8] = $mName

	  ; Set Hotkey
	  $mHotkey = IniRead($sFilePath, $mSection, "Hotkey", "-")
	  GUICtrlSetData($g_aMultiPressers[$k][11], HexToKey($mHotkey))
	  $g_aMultiPressers[$k][10] = $mHotkey

	  ; Set icon
	  $mIcon = IniRead($sFilePath, $mSection, "Icon", "")
	  If $mIcon = "" Then
		 $mIcon = "none.jpg"
	  EndIf
	  GUICtrlSetImage($g_aMultiPressers[$k][12], @ScriptDir & "\Icons\" & $mIcon)
	  $g_aMultiPressers[$k][13] = $mIcon
   Next
EndFunc ;==>_IniLoad

Func _CalcSpammerCount()
   Local $count = 0
   For $n = 0 To UBound($g_Tabs) - 1
	  $count = $count + $g_Tabs[$n][1]
   Next
   Return $count
EndFunc ;==>_CalcSpammerCount

Func _CalcPresserCount()
   Local $count = 0
   For $n = 0 To UBound($g_Tabs) - 1
	  $count = $count + $g_Tabs[$n][2]
   Next
   Return $count
EndFunc ;==>_CalcPresserCount

Func _CalcBiggestTab(ByRef $iMaxDepth, ByRef $iMaxRows, $iRows)
   Local $count = 0
   For $n = 0 To UBound($g_Tabs) - 1
	  Local $new_count = $g_Tabs[$n][1] + $g_Tabs[$n][2]
	  If $new_count > $count Then
		 $count = $new_count
	  EndIf
   Next
   $iMaxDepth = Ceiling($count / $iRows) ; rounded up
   If $count < $iRows Then
	  $iMaxRows = $count
   Else
	  $iMaxRows = $iRows
   EndIf
EndFunc ;==>_CalcBiggestTab

; Settings Window
Local $hSettingsGUI
Local $SettingsTabList
Local $SettingsTabListContent
Local $SettingsWindowName
Local $SettingsOrientation
Local $SettingsRowsCombo
Local $SettingsRows

Func _OnSettingsClick()
   $bSettingsOpen = True

   Local $iSettingsHeight = 763
   Local $iSettingsWidth = 286

   $hSettingsGUI = GUICreate("Settings", $iSettingsWidth, $iSettingsHeight, WinGetPos($hMainGUI)[0], WinGetPos($hMainGUI)[1]+50)
   GUICtrlCreateLabel("", 0, 0, $iWinWidth, $iSettingsHeight)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)
   GUICtrlSetState(-1, $GUI_DISABLE)

   Local Const $iCol1=18, $iCol2=30, $iCol3=230

   ; List
   $SettingsTabListContent = _ReadTabListContent()
   GUISetFont(9, 800)
   GUICtrlCreateLabel("Tabs", 20, 16)
   GUISetFont(9, 400)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)
   $SettingsTabList = GUICtrlCreateList("", $iCol1, 36, 200, 100, BitOr($WS_BORDER, $WS_VSCROLL)) ; omit $LBS_SPRT style to not have it sorted alpabetically
   GUICtrlSetData(-1, $SettingsTabListContent)
   GUICtrlSetColor(-1, $COLOR_BLACK)
   GUICtrlSetBkColor(-1, $COLOR_WHITE)

   ; Add button
   GUICtrlCreateButton("Add", $iCol3, 0 + 36, 44, 20)
   GUICtrlSetOnEvent(-1, "_OnSettingsButtonClickAdd")
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK1)

   ; Edit button
   GUICtrlCreateButton("Edit", $iCol3, 25 + 36, 44, 20)
   GUICtrlSetOnEvent(-1, "_OnSettingsButtonClickEdit")
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK1)

   ; Delete button
   GUICtrlCreateButton("Delete", $iCol3, 50 + 36, 44, 20)
   GUICtrlSetOnEvent(-1, "_OnSettingsButtonClickDelete")
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK1)

   ; Example Label
   GUICtrlCreateLabel("Tabname,Spammercount,Pressercount" & @CRLF & "Example: Default,4,1", $iCol1, 138)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)

   ; Orientation Radio
   $SettingsOrientation = IniRead($sFilePath, "General", "Orientation", "vertical")
   Local $OrientationY = 182
   GUISetFont(9, 800)
   GUICtrlCreateLabel("Orientation", 20, $OrientationY)
   GUISetFont(9, 400)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)

   Local $idRadioV = GUICtrlCreateRadio("Vertical ", $iCol2, $OrientationY + 16)
   DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($idRadioV), "wstr", 0, "wstr", 0) ; Default Theme, so Radio can be customized
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)
   GUICtrlSetState(-1, 1) ; 1 = checked
   GUICtrlSetOnEvent(-1, "_OnOrientationClickVertical")

   Local $idRadioH = GUICtrlCreateRadio("Horizontal ", $iCol2 + 100, $OrientationY + 16)
   DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($idRadioH), "wstr", 0, "wstr", 0) ; Default Theme, so Radio can be customized
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)
   GUICtrlSetOnEvent(-1, "_OnOrientationClickHorizontal")

   If $SettingsOrientation <> "horizontal" Then
	  GUICtrlSetState($idRadioV, 1) ; 1 = checked
   Else
	  GUICtrlSetState($idRadioH, 1) ; 1 = checked
   EndIf

   GUICtrlCreateLabel("Number of Rows:", $iCol2, $OrientationY + 42)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)

   ; Rows Combo
   $SettingsRowsCombo = GUICtrlCreateCombo("", $iCol2 + 100, $OrientationY + 38, 36, 12, $CBS_DROPDOWNLIST)
   $SettingsRows = IniRead($sFilePath, "General", "Rows", 1)
   GUICtrlSetData($SettingsRowsCombo, "1|2|3|4|5|6|7|8|9", $SettingsRows)
   GUICtrlCreateLabel("Direction and Rows for spammers and " & @CRLF & "pressers. Example: 8 spammers vertical with " & @CRLF & "2 rows will make a grid of width 2 and height 4.", $iCol1, $OrientationY + 62)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)

   ; Window Name
   Local $WindowNameY = 300
   Local $WindowNameIni = IniRead($sFilePath, "General", "WindowName", "; - Forsaken Kingdom")

   GUISetFont(9, 800)
   GUICtrlCreateLabel("Window Name", $iCol1, $WindowNameY)
   GUISetFont(9, 400)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)
   $SettingsWindowName = GUICtrlCreateInput($WindowNameIni, $iCol1, $WindowNameY + 20, 250, 20)
   GUICtrlSetColor(-1, $COLOR_BLACK)
   GUICtrlSetBkColor(-1, $COLOR_WHITE)
   GUICtrlCreateLabel("Name of the FlyFF window." & @CRLF & "Replace the character name with a semicolon.", $iCol1, $WindowNameY + 48)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)


   ; Hotkey Base
   Local $HotkeysY = 410

   ; Label
   GUISetFont(9, 800)
   GUICtrlCreateLabel("Base key for the hotkeys", $iCol1, $HotkeysY - 20)
   GUISetFont(9, 400)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)

   ; Spam
   GUICtrlCreateLabel("Spammer: ", $iCol1, $HotkeysY)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)
   Global $u_HotkeySpammer = GUICtrlCreateLabel(_HexToKey($iHotkeyBaseSpam), $iCol1 + 80, $HotkeysY, 100)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)
   GUICtrlCreateButton("Edit", $iCol3 - 40, $HotkeysY - 4, 44, 20)
   GUICtrlSetOnEvent(-1, "_OnSettingsButtonClickEditHotkeySpam")
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK1)

   ; Press
   GUICtrlCreateLabel("Presser: ", $iCol1, $HotkeysY + 28)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)
   Global $u_HotkeyPresser = GUICtrlCreateLabel(_HexToKey($iHotkeyBasePress), $iCol1 + 80, $HotkeysY + 28, 100)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)
   GUICtrlCreateButton("Edit", $iCol3 - 40, $HotkeysY + 28 - 4, 44, 20)
   GUICtrlSetOnEvent(-1, "_OnSettingsButtonClickEditHotkeyPress")
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK1)

   ; Sounds
   Local $SoundsY = 465
   ; Press
   GUISetFont(9, 800)
   GUICtrlCreateLabel("Sounds ", $iCol1, $SoundsY)
   GUISetFont(9, 400)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)

   Global $SoundsEnabledCheckbox = GUICtrlCreateCheckbox("", $iCol1, $SoundsY + 17, 20, 20)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)
   GUICtrlSetState($SoundsEnabledCheckbox, $bSoundsEnabled)
   GUICtrlCreateLabel("Enabled", $iCol1 + 20, $SoundsY + 20)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)

   GUICtrlCreateLabel("Spam Start: ", $iCol1, $SoundsY + 48)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)
   Global $u_SpammerStartSound = GUICtrlCreateLabel($sSoundFileSpamStart, $iCol1 + 80, $SoundsY + 48, 100)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)
   GUICtrlCreateButton("Edit", $iCol3 - 40, $SoundsY + 48, 44, 20)
   GUICtrlSetOnEvent(-1, "_OnSettingsButtonSoundsClickSpammerStart")
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK1)

   GUICtrlCreateLabel("Spam Stop: ", $iCol1, $SoundsY + 76)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)
   Global $u_SpammerStopSound = GUICtrlCreateLabel($sSoundFileSpamStop, $iCol1 + 80, $SoundsY + 76, 100)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)
   GUICtrlCreateButton("Edit", $iCol3 - 40, $SoundsY + 76, 44, 20)
   GUICtrlSetOnEvent(-1, "_OnSettingsButtonSoundsClickSpammerStop")
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK1)

   GUICtrlCreateLabel("Presser: ", $iCol1, $SoundsY + 104)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)
   Global $u_PresserSound = GUICtrlCreateLabel($sSoundFilePresser, $iCol1 + 80, $SoundsY + 104, 100)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)
   GUICtrlCreateButton("Edit", $iCol3 - 40, $SoundsY + 104, 44, 20)
   GUICtrlSetOnEvent(-1, "_OnSettingsButtonSoundsClickPresser")
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK1)

   ; KeyLoopTime
   Local $KeyLoopTimeY = 598

   GUISetFont(9, 800)
   GUICtrlCreateLabel("Key Loop Time", $iCol1, $KeyLoopTimeY)
   GUISetFont(9, 400)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)
   Global $KeyLoopTimeInput = GUICtrlCreateInput($iKeyLoopTime, $iCol1, $KeyLoopTimeY + 20, 250, 20)
   GUICtrlSetColor(-1, $COLOR_BLACK)
   GUICtrlSetBkColor(-1, $COLOR_WHITE)
   GUICtrlCreateLabel("Amount of time in ms to wait between checking" & @CRLF & "for key inputs. Lower number means faster" & @CRLF & "reaction but more CPU usage.", $iCol1, $KeyLoopTimeY + 48)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)


   ; Buttons at Bottom
   Local $ButtonsY = 723

   ; Save button
   GUICtrlCreateButton("Save", 140, $ButtonsY, 60, 30)
   GUICtrlSetOnEvent(-1, "_OnSettingsButtonClickSave")
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK1)

   ; Cancel button
   GUICtrlCreateButton("Cancel", 212, $ButtonsY, 60, 30)
   GUICtrlSetOnEvent(-1, "_ExitSettings")
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK1)

   ; Restart Label
   GUICtrlCreateLabel("Most changes will" & @CRLF & "only take effect after" & @CRLF & "restarting the tool!", $iCol1, $ButtonsY - 16)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)

   ; Display the GUI
   GUISetState(@SW_SHOW, $hSettingsGUI)

   ; Register close event handler
   GUISetOnEvent($GUI_EVENT_CLOSE, "_ExitSettings")
EndFunc   ;==>_OnSettingsClick

Func _ExitSettings()
   $bSettingsOpen = False
   GUISetState(@SW_HIDE, $hSettingsGUI)
EndFunc ;==>_ExitSettings

Local $tab_text = "Specify a tabname, amount of spammers, and amount of pressers." & @CRLF & "Example: Default,4,1"

Local $HotkeyBaseText = "Press a key." & @CRLF & "This key will be the base for this hotkey." & @CRLF & "Example: Press SHIFT and your hotkeys will be SHIFT + the key you set for the action." & @CRLF & "Some keys might be displayed as ?? but will still work."

Func _OnSettingsButtonClickEditHotkeySpam()
   ; Get presser index
   SplashTextOn("Edit hotkey base for spammers", $HotkeyBaseText, 300, 100, WinGetPos($hMainGUI)[0], WinGetPos($hMainGUI)[1]+100, 0, "", 8)
   Local $pressed = False
   ; loop until key is pressed
   While Not $pressed
	  ; check all possible keys
	  For $h = 8 To 254
		 Local $hex = Hex($h)
		 If _IsPressed($hex, $hDLL) Then
			$iHotkeyBaseSpam = $hex
			GUICtrlSetData($u_HotkeySpammer, _HexToKey($hex))
			$pressed = True
			ExitLoop
		 EndIf
	  Next
   WEnd
   SplashOff()
EndFunc   ;==>_OnSettingsButtonClickEditHotkeySpam

Func _OnSettingsButtonClickEditHotkeyPress()
   ; Get presser index
   SplashTextOn("Edit hotkey base for pressers", $HotkeyBaseText, 300, 100, WinGetPos($hMainGUI)[0], WinGetPos($hMainGUI)[1]+100, 0, "", 8)
   Local $pressed = False
   ; loop until key is pressed
   While Not $pressed
	  ; check all possible keys
	  For $h = 8 To 254
		 Local $hex = Hex($h)
		 If _IsPressed($hex, $hDLL) Then
			$iHotkeyBasePress = $hex
			GUICtrlSetData($u_HotkeyPresser, _HexToKey($hex))
			$pressed = True
			ExitLoop
		 EndIf
	  Next
   WEnd
   SplashOff()
EndFunc   ;==>_OnSettingsButtonClickEditHotkeyPress

Func _OnSettingsButtonClickAdd()
   Local $input = InputBox("Add tab", $tab_text, "", "", 300, 160)
   $SettingsTabListContent = $SettingsTabListContent & "|" & $input
   _UpdateTabListContent()
EndFunc   ;==>_OnSettingsButtonClickAdd

Func _OnSettingsButtonClickDelete()
  Local $iSelected = GUICtrlRead($SettingsTabList)
  if $iSelected <> "" Then
	  $SettingsTabListContent = StringReplace($SettingsTabListContent, $iSelected, "", 1, 1)
	  _UpdateTabListContent()
  EndIf
EndFunc   ;==>_OnSettingsButtonClickDelete

Func _OnSettingsButtonClickEdit()
   Local $iSelected = GUICtrlRead($SettingsTabList)
   If $iSelected <> "" Then
	  Local $input = InputBox("Edit tab", $tab_text, $iSelected, "", 300, 160)
	  If $input <> "" Then
		 $SettingsTabListContent = StringReplace($SettingsTabListContent, $iSelected, $input, 1, 1)
		 _UpdateTabListContent()
	  EndIf
   EndIf
EndFunc   ;==>_OnSettingsButtonClickEdit

Func _ReadTabListContent()
   Local $array = _getTabArray()
   Local $ContentString = ""
   For $i = 0 To UBound($array) - 1
	  $ContentString &= $array[$i][0] & "," & $array[$i][1] & "," & $array[$i][2] & "|"
   Next
   $ContentString = StringTrimRight($ContentString, 1) ; remove last "|"
   Return $ContentString
EndFunc   ;==>_ReadTabListContent

Func _UpdateTabListContent()
   Local $contentArray = StringSplit($SettingsTabListContent, "", 2) ; Flag for no count as first element
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
   $SettingsTabListContent = $iNewContent
   GUICtrlSetData($SettingsTabList, "")
   GUICtrlSetData($SettingsTabList, $SettingsTabListContent)
EndFunc   ;==>_UpdateTabListContent

Func _OnSettingsButtonClickSave()
   IniWrite($sFilePath, "General", "Orientation", $SettingsOrientation)
   $SettingsRows = GUICtrlRead($SettingsRowsCombo)
   IniWrite($sFilePath, "General", "Rows", $SettingsRows)
   IniWrite($sFilePath, "General", "HotkeyBaseSpammer", $iHotkeyBaseSpam)
   IniWrite($sFilePath, "General", "HotkeyBasePresser", $iHotkeyBasePress)
   $iKeyLoopTime = GUICtrlRead($KeyLoopTimeInput)
   IniWrite($sFilePath, "General", "KeyLoopTime", $iKeyLoopTime)
   Local $WindowNameInput = GUICtrlRead($SettingsWindowName)
   If $SettingsTabListContent <> "" And $WindowNameInput <> "" Then
	  Local $contentArray = StringSplit($SettingsTabListContent, "|", 2) ; Flag for no count as first element
	  IniWrite($sFilePath, "General", "Tabs", UBound($contentArray))
	  For $i = 0 To UBound($contentArray) - 1
		 Local $TabValues = StringSplit($contentArray[$i], ",", 2) ; Flag for no count as first element
		 IniWrite($sFilePath, "General", "tab" & $i+1, $TabValues[0])
		 IniWrite($sFilePath, "General", "tab" & $i+1 & "spammers", $TabValues[1])
		 IniWrite($sFilePath, "General", "tab" & $i+1 & "pressers", $TabValues[2])
	  Next
	  IniWrite($sFilePath, "General", "WindowName", $WindowNameInput)
	  _ExitSettings()
   Else
	  MsgBox(0, "Invalid inputs!", "Inputs can't be empty.")
   EndIf
   Local $SoundsEnabledCheckboxState = GUICtrlRead($SoundsEnabledCheckbox)
   $bSoundsEnabled = $SoundsEnabledCheckboxState
   IniWrite($sFilePath, "General", "SoundsEnabled", $SoundsEnabledCheckboxState)
   Local $SoundSpammerStart = GUICtrlRead($u_SpammerStartSound)
   $sSoundFileSpamStart = $SoundSpammerStart
   IniWrite($sFilePath, "General", "SoundSpamStart", $SoundSpammerStart)
   Local $SoundSpammerStop = GUICtrlRead($u_SpammerStopSound)
   $sSoundFileSpamStop = $SoundSpammerStop
   IniWrite($sFilePath, "General", "SoundSpamStop", $SoundSpammerStop)
   Local $SoundPresser = GUICtrlRead($u_PresserSound)
   $sSoundFilePresser = $SoundPresser
   IniWrite($sFilePath, "General", "SoundPresser", $SoundPresser)
EndFunc   ;==>_OnSettingsButtonClickSave

Func _OnOrientationClickVertical()
   $SettingsOrientation = "vertical"
EndFunc   ;==>_OnOrientationClickVertical

Func _OnOrientationClickHorizontal()
   $SettingsOrientation = "horizontal"
EndFunc   ;==>_OnOrientationClickHorizontal

Func _OnSettingsButtonSoundsClickSpammerStart()
   SetNewSoundLabel($u_SpammerStartSound)
EndFunc

Func _OnSettingsButtonSoundsClickSpammerStop()
   SetNewSoundLabel($u_SpammerStopSound)
EndFunc

Func _OnSettingsButtonSoundsClickPresser()
   SetNewSoundLabel($u_PresserSound)
EndFunc

Func SetNewSoundLabel($GUIControlId)
   Local $soundPath = @ScriptDir & "\Sounds\"
   Local $sFileOpenDialog = FileOpenDialog("Pick a new sound", $soundPath, "Audio (*.mp3)")
   If $sFileOpenDialog <> "" Then
	  If not @error Then
		 If StringInStr($sFileOpenDialog, $soundPath) <> 0 Then
			Local $iFilename = StringReplace($sFileOpenDialog, $soundPath, "") ; convert dir to filename
			GUICtrlSetData($GUIControlId, $iFilename)
		 Else
			MsgBox(0, "Invalid path!", "File has to be located in Sounds folder!")
		 EndIf
	  EndIf
   EndIf
EndFunc

Func _HexToKey($hex)
   $SettingsOrientation = "horizontal"
   If $hex = "000000A2" Or $hex = "00000011" Then
	  Return "CTRL"
   ElseIf $hex = "000000A0" Or $hex = "00000010" Then
	  Return "SHIFT"
   ElseIf $hex = "000000A4" Or $hex = "00000012" Then
	  Return "ALT"
   Else
	  Return HexToKey($hex)
   EndIf
EndFunc   ;==>_HexToKey


