#include-once

Local Const $sFilePath = @ScriptDir & "\Settings.ini"

Func _IniSave()
  Local $sSection = "", $sFKey, $sSkill
  For $i = 0 To UBound($g_aSpammers) - 1
    $sSection = "Spammer" & $i + 1

    ; Check whitespace from fkey and skill
    $sFKey = GUICtrlRead($g_aSpammers[$i][$g_eSpamFKey])
    If $sFKey = " " Then $sFKey = ""

    $sSkill = GUICtrlRead($g_aSpammers[$i][$g_eSpamSkill])
    If $sSkill = " " Then $sSkill = ""

    ; Save window title, interval, icons, FKey, Skill
    IniWrite($sFilePath, $sSection, "WindowTitle", GUICtrlRead($g_aSpammers[$i][$g_eSpamWindow]))
    IniWrite($sFilePath, $sSection, "Interval", GUICtrlRead($g_aSpammers[$i][$g_eSpamInterval]))
	IniWrite($sFilePath, $sSection, "Icon1", $g_aSpammers[$i][$g_eIcon1Path])
	IniWrite($sFilePath, $sSection, "Icon2", $g_aSpammers[$i][$g_eIcon2Path])
    IniWrite($sFilePath, $sSection, "FKey", $sFKey)
    IniWrite($sFilePath, $sSection, "Skill", $sSkill)
  Next

   Local $mSection = ""
  For $k = 0 To UBound($g_aMultiPressers) - 1
    $mSection = "MultiPresser" & $k + 1

    ; Save Content
    IniWrite($sFilePath, $mSection, "Content", $g_aMultiPressers[$k][4])
  Next
EndFunc ;==>_IniSave

Func _ReadWinPosition(ByRef $iWinLeft, ByRef $iWinTop)
   $iWinLeft = IniRead($sFilePath, "General", "Left", -1)
   $iWinTop = IniRead($sFilePath, "General", "Top", -1)
EndFunc

Func _ReadOrientation(ByRef $iOrientation)
   $iOrientation = IniRead($sFilePath, "General", "Orientation", "vertical")
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
    If $sWindowTitle = "" Then $sWindowTitle = $g_sSelectWindow
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

	; Set icon2
    $iIcon2 = IniRead($sFilePath, $sSection, "Icon2", "")
	If $iIcon2 = "" Then
	   $iIcon2 = "none.jpg"
    EndIf
    GUICtrlSetImage($g_aSpammers[$i][$g_eIcon2], @ScriptDir & "\Icons\" & $iIcon2)
	$g_aSpammers[$i][$g_eIcon2Path] = $iIcon2

    ; Set fkey
    $sFKey = IniRead($sFilePath, $sSection, "FKey", " ")
    GUICtrlSetData($g_aSpammers[$i][$g_eSpamFKey], "F1|F2|F3|F4|F5|F6|F7|F8|F9", $sFKey)

    ; Set skill
    $sSkill = IniRead($sFilePath, $sSection, "Skill", "-")
    GUICtrlSetData($g_aSpammers[$i][$g_eSpamSkill], "1|2|3|4|5|6|7|8", $sSkill)
  Next

 For $k = 0 to UBound($g_aMultiPressers) - 1
    $mSection = "MultiPresser" & $k + 1

    ; Set Content
    $mContent = IniRead($sFilePath, $mSection, "Content", "")
	$g_aMultiPressers[$k][4] = $mContent
    GUICtrlSetData($g_aMultiPressers[$k][3], $mContent)
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

Func _CalcBiggestTab()
   Local $count = 0
   For $n = 0 To UBound($g_Tabs) - 1
	  Local $new_count = $g_Tabs[$n][1] + $g_Tabs[$n][2]
	  If $new_count > $count Then
		 $count = $new_count
	  EndIf
   Next
   Return $count
EndFunc ;==>_CalcBiggestTab


; Settings Window
Local $hSettingsGUI
Local $SettingsTabList
Local $SettingsTabListContent
Local $SettingsWindowName
Local $SettingsOrientation

Func _OnSettingsClick()
   Local $iSettingsHeight = 398
   Local $iSettingsWidth = 286

   $hSettingsGUI = GUICreate("Settings", $iSettingsWidth, $iSettingsHeight, $iWinLeft, $iWinTop+50)
   GUICtrlCreateLabel("", 0, 0, $iWinWidth, $iSettingsHeight)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)
   GUICtrlSetState(-1, $GUI_DISABLE)

   Local Const $iCol1=18, $iCol2=30, $iCol3=230

   ; List
   $SettingsTabListContent = _ReadTabListContent()
   GUICtrlCreateLabel("Tabs", 20, 16)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)
   $SettingsTabList = GUICtrlCreateList("", $iCol1, 36, 200, 100)
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
   GUICtrlCreateLabel("Tabname,Spammercount,Pressercount" & @CRLF & "Example: Default,4,1" & @CRLF & "Changes will take effect after restarting the tool.", $iCol1, 138)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)

   ; Orientation Radio
   $SettingsOrientation = IniRead($sFilePath, "General", "Orientation", "vertical")
   Local $OrientationY = 190
   GUICtrlCreateLabel("Orientation", 20, $OrientationY)
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

   GUICtrlCreateLabel("Direction, in which spammers and pressers" & @CRLF & "will be placed.", $iCol1, $OrientationY + 38)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)

   ; Window Name
   Local $WindowNameY = 270
   Local $WindowNameIni = IniRead($sFilePath, "General", "WindowName", "; - Forsaken Kingdom")

   GUICtrlCreateLabel("Window Name", $iCol1, $WindowNameY)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)
   $SettingsWindowName = GUICtrlCreateInput($WindowNameIni, $iCol1, $WindowNameY + 20, 250, 20)
   GUICtrlSetColor(-1, $COLOR_BLACK)
   GUICtrlSetBkColor(-1, $COLOR_WHITE)
   GUICtrlCreateLabel("Name of the FlyFF window." & @CRLF & "Replace the character name with a semicolon.", $iCol1, $WindowNameY + 48)
   GUICtrlSetColor(-1, $COLOR_WHITE)
   GUICtrlSetBkColor(-1, $COLOR_DARK2)

   ; Buttons at Bottom
   Local $ButtonsY = 360
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

   ; Display the GUI
   GUISetState(@SW_SHOW, $hSettingsGUI)

   ; Register close event handler
   GUISetOnEvent($GUI_EVENT_CLOSE, "_ExitSettings")
EndFunc   ;==>_OnSettingsClick

Func _ExitSettings()
   GUISetState(@SW_HIDE, $hSettingsGUI)
EndFunc ;==>_ExitSettings

Local $tab_text = "Specify a tabname, amount of spammers, and amount of pressers." & @CRLF & "Example: Default,4,1"

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
  if $iSelected <> "" Then
	  Local $input = InputBox("Edit tab", $tab_text, $iSelected, "", 300, 160)
	  if $input <> "" Then
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
   $ContentString = StringTrimRight($ContentString, 1) ; Letztes | wieder weg
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
EndFunc   ;==>_OnSettingsButtonClickSave

Func _OnOrientationClickVertical()
   $SettingsOrientation = "vertical"
EndFunc   ;==>_OnOrientationClickVertical

Func _OnOrientationClickHorizontal()
   $SettingsOrientation = "horizontal"
EndFunc   ;==>_OnOrientationClickHorizontal


