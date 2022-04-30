#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Resources\aibatt.ico
#AutoIt3Wrapper_Res_Description=FTool by Amenti
#AutoIt3Wrapper_Res_Fileversion=2.2
#AutoIt3Wrapper_Res_ProductName=FTool by Amenti
#AutoIt3Wrapper_Res_ProductVersion=2.2
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; Mandatory execution as administrator
#RequireAdmin
#include <Misc.au3>
#include "Include\Constants.au3"
#include "Include\Settings.au3"
#include "Include\Spam.au3"
#include "Include\Multipress.au3"
#include "Include\Windows.au3"


; AutoItSetOption
Opt("GuiOnEventMode", 1) ; Change to OnEvent mode
Opt("TrayMenuMode", 1) ; Disable default tray menu
Opt("TrayOnEventMode", 1) ; Enable OnEvent functions notifications for the tray

; GUI Window variables
Local const $sTitle = "FTool by Amenti 2.2"
Local $iWinWidth = 286
Local $iWinHeight = 420
Local $iWinLeft = -1
Local $iWinTop = -1
Local $iOrientation = "vertical"

; Colors
Global $COLOR_GREEN = 0x0f801b
Global $COLOR_WHITE = 0xd9d9d9
Global $COLOR_DARK1 = 0x757575
Global $COLOR_DARK2 = 0x525252
Global $COLOR_DARK3 = 0x323233
Global $COLOR_BLACK = 0x000000

; Read from settings.ini
_ReadWinPosition($iWinLeft, $iWinTop)
_ReadOrientation($iOrientation)
Global $g_Tabs = _getTabArray() ; Two-dimensional: [ArrayNumber][0 = Name, 1 = Spammers, 2 = MultiPressers]

Local $iMaxItems = _CalcBiggestTab()

If $iOrientation <> "horizontal" Then
   $iWinHeight = 20 + ($iMaxItems * 99) + 6
   $iWinWidth = 286
Else
   $iWinWidth = (_CalcBiggestTab() * 280) + 6
   $iWinHeight = 20 + 99 + 6
EndIf



Local $iSpammerCount = _CalcSpammerCount()
Local $iPresserCount = _CalcPresserCount()

; Spammer and Presser variables
Global Enum $g_eSpamButton, $g_eDefColor, $g_eSpamColor, $g_eSpamWindow, $g_eSpamInterval, $g_eSpamFKey, $g_eSpamSkill, $g_eSpamPID, $g_eSpamWindowTitle, $g_eIcon1, $g_eIcon1Path, $g_eHotkey, $g_eHotkeyButton, $g_eHotkeyLabel
Global $g_aSpammers[$iSpammerCount][14] ; 9 = Icon1 GUICtrl, 10 = Icon1 Path, 11 = Hotkey, 12 = HotkeyButton, 13 = HotkeyLabel
Global $g_aMultiPressers[$iPresserCount][8] ; 0 = Button, 1 = DefColor, 2 = SpamColor, 3 = List, 4 = ListContent, 5 = addButton, 6 = deleteButton, 7 = editButton
Global const $g_sSelectWindow = "Select Window"

; Create GUI window
Local $hMainGUI = GUICreate($sTitle, $iWinWidth, $iWinHeight, $iWinLeft, $iWinTop)

; Window Background Color
GUICtrlCreateLabel("", 0, 20, $iWinWidth, $iWinHeight-20)
GUICtrlSetBkColor(-1, $COLOR_DARK3)
GUICtrlSetState(-1, $GUI_DISABLE)

; Register close event handler
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

; Create a tray exit option
TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "_Exit")

GUICtrlSetDefColor($COLOR_WHITE)

; Settings button
GUICtrlCreatePic(@ScriptDir & "\Resources\" & "settings.jpg", $iWinWidth - 18, 2, 16, 16)
GUICtrlSetOnEvent(-1, "_OnSettingsClick")


#Region TABS & SPAMMERS
	GUICtrlCreateTab(0, 0, $iWinWidth + 2, $iWinHeight + 1)

	; GUI variables
	Local Const $iCol1=80, $iCol2=227, $iCol3=7, $iLeft = 6, $iTop = 26
	Local $iSpaceY=99, $iSpaceX=280

    Local $spammerNumber = 0
	Local $presserNumber = 0
	For $i = 0 To UBound($g_Tabs) - 1
		GUICtrlCreateTabItem($g_Tabs[$i][0])

		If $iOrientation <> "horizontal" Then
		 ;vertical
		 $iSpaceX = 0
	    Else
		 ;horizontal
		 $iSpaceY = 0
	    EndIf

	    ;Spammers
		For $j = 0 To $g_Tabs[$i][1] - 1

			; Group Color (+ Hidden Color)
			$g_aSpammers[$spammerNumber][$g_eDefColor] =  GUICtrlCreateLabel("", $iLeft + ($j * $iSpaceX), $iTop + ($j * $iSpaceY), 273, 92)
			GUICtrlSetBkColor(-1, $COLOR_DARK2)
			GUICtrlSetState(-1, $GUI_DISABLE)

			$g_aSpammers[$spammerNumber][$g_eSpamColor] =  GUICtrlCreateLabel("", $iLeft + ($j * $iSpaceX), $iTop + ($j * $iSpaceY), 273, 92)
			GUICtrlSetBkColor(-1, $COLOR_GREEN)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)

			GUICtrlCreateGroup("", $iLeft + ($j * $iSpaceX), $iTop-6 + ($j * $iSpaceY), 274, 101)

			; Hidden label to save spammer index
			GUICtrlCreateLabel($spammerNumber, -99, -99)
			GUICtrlSetState(-1, $GUI_HIDE)

			; Start button
			GUICtrlCreateLabel("Spammer", $iLeft + $iCol3 + ($j * $iSpaceX), $iTop+7 + ($j * $iSpaceY))
			$g_aSpammers[$spammerNumber][$g_eSpamButton] = GUICtrlCreateButton("Start", $iLeft+7 + ($j * $iSpaceX), $iTop+21 + ($j * $iSpaceY), 64, 64)
			GUICtrlSetOnEvent(-1, "_OnButtonClickSpam")
			GUICtrlSetBkColor(-1, $COLOR_DARK1)

			; Select window
			GUICtrlCreateLabel("Window", $iLeft+$iCol1 + ($j * $iSpaceX), $iTop+7 + ($j * $iSpaceY))
			$g_aSpammers[$spammerNumber][$g_eSpamWindow] = GUICtrlCreateCombo($g_sSelectWindow, $iLeft+$iCol1 + ($j * $iSpaceX), $iTop+22 + ($j * $iSpaceY), 138, 20, $CBS_DROPDOWNLIST)

			; Interval
			GUICtrlCreateLabel("Interval (ms)", $iLeft+$iCol1 + ($j * $iSpaceX), $iTop+49 + ($j * $iSpaceY))
			$g_aSpammers[$spammerNumber][$g_eSpamInterval] = GUICtrlCreateInput("0", $iLeft+$iCol1 + ($j * $iSpaceX), $iTop+64 + ($j * $iSpaceY), 56, 20, $ES_NUMBER)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			GUICtrlSetBkColor(-1, $COLOR_WHITE)

			; Icon1
			$g_aSpammers[$spammerNumber][$g_eIcon1] = GUICtrlCreatePic("", $iLeft+$iCol1 + 62 + ($j * $iSpaceX), $iTop+52 + ($j * $iSpaceY), 31, 31)
			$g_aSpammers[$spammerNumber][$g_eIcon1Path] = ""
			GUICtrlSetOnEvent(-1, "_OnIconClick1")

			; Hotkey
			GUICtrlCreateLabel("Hotkey:", $iLeft+$iCol1 + 99 + ($j * $iSpaceX), $iTop+49 + ($j * $iSpaceY))
			$g_aSpammers[$spammerNumber][$g_eHotkeyLabel] = GUICtrlCreateInput("-", $iLeft+$iCol1 + 99 + ($j * $iSpaceX), $iTop+64 + ($j * $iSpaceY), 19, 20)
			GUICtrlSetState(-1, $GUI_DISABLE)
			$g_aSpammers[$spammerNumber][$g_eHotkeyButton] = GUICtrlCreateButton("+", $iLeft+$iCol1 + 120 + ($j * $iSpaceX), $iTop+64 + ($j * $iSpaceY), 14, 20)
			GUICtrlSetOnEvent(-1, "_OnButtonClickHotkey")
			GUICtrlSetBkColor(-1, $COLOR_DARK1)

			; F-Key
			GUICtrlCreateLabel("F-Key", $iLeft+$iCol2 + ($j * $iSpaceX), $iTop+7 + ($j * $iSpaceY))
			$g_aSpammers[$spammerNumber][$g_eSpamFKey] = GUICtrlCreateCombo(" ", $iLeft+$iCol2 + ($j * $iSpaceX), $iTop+22 + ($j * $iSpaceY), 40, 20, $CBS_DROPDOWNLIST)

			; Skill bar
			GUICtrlCreateLabel("Skill Bar", $iLeft+$iCol2 + ($j * $iSpaceX), $iTop+49 + ($j * $iSpaceY))
			$g_aSpammers[$spammerNumber][$g_eSpamSkill] = GUICtrlCreateCombo("-", $iLeft+$iCol2 + ($j * $iSpaceX), $iTop+64 + ($j * $iSpaceY), 40, 20, $CBS_DROPDOWNLIST)

			$spammerNumber += 1
		 Next

		;MultiPressers
	    For $n = $g_Tabs[$i][1] To ($g_Tabs[$i][1] + $g_Tabs[$i][2]) - 1

			; Group color
			$g_aMultiPressers[$presserNumber][2] =  GUICtrlCreateLabel("", $iLeft + ($n * $iSpaceX), $iTop+1 + ($n * $iSpaceY), 273, 92)
			GUICtrlSetBkColor(-1, $COLOR_DARK2)
			GUICtrlSetState(-1, $GUI_DISABLE)

			GUICtrlCreateGroup("", $iLeft + ($n * $iSpaceX), $iTop-6 + ($n * $iSpaceY), 274, 101)

			; Hidden label to save presser index
			GUICtrlCreateLabel($presserNumber, -99, -99)
			GUICtrlSetState(-1, $GUI_HIDE)

			; Press button
			GUICtrlCreateLabel("Presser", $iLeft+$iCol3 + ($n * $iSpaceX), $iTop+7 + ($n * $iSpaceY))
			$g_aMultiPressers[$presserNumber][0] = GUICtrlCreateButton("Press", $iLeft+$iCol3 + ($n * $iSpaceX), $iTop+21 + ($n * $iSpaceY), 64, 64)
			GUICtrlSetOnEvent(-1, "_OnButtonClickMultiPress")
			GUICtrlSetBkColor(-1, $COLOR_DARK1)

			; List
			GUICtrlCreateLabel("Actions", $iLeft+$iCol1 + ($n * $iSpaceX), $iTop+7 + ($n * $iSpaceY))
			$g_aMultiPressers[$presserNumber][3] = GUICtrlCreateList("", $iLeft+$iCol1 + ($n * $iSpaceX), $iTop+22 + ($n * $iSpaceY), 130, 64)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			GUICtrlSetBkColor(-1, $COLOR_WHITE)

			; Add button
			$g_aMultiPressers[$presserNumber][5] = GUICtrlCreateButton("Add", $iLeft+$iCol2 - 7 + ($n * $iSpaceX), $iTop+10 + ($n * $iSpaceY), 44, 20)
			GUICtrlSetOnEvent(-1, "_OnButtonClickAdd")
			GUICtrlSetBkColor(-1, $COLOR_DARK1)

			; Edit button
			$g_aMultiPressers[$presserNumber][7] = GUICtrlCreateButton("Edit", $iLeft+$iCol2 - 7 + ($n * $iSpaceX), $iTop+36 + ($n * $iSpaceY), 44, 20)
			GUICtrlSetOnEvent(-1, "_OnButtonClickEdit")
			GUICtrlSetBkColor(-1, $COLOR_DARK1)

			; Delete button
			$g_aMultiPressers[$presserNumber][6] = GUICtrlCreateButton("Delete", $iLeft+$iCol2 - 7 + ($n * $iSpaceX), $iTop+62 + ($n * $iSpaceY), 44, 20)
			GUICtrlSetOnEvent(-1, "_OnButtonClickDelete")
			GUICtrlSetBkColor(-1, $COLOR_DARK1)

			$presserNumber += 1
		 Next
	Next
#EndRegion

; Detect dropdown events
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

_IniLoad() ; Read the INI file and get the saved values

; Display the GUI
GUISetState(@SW_SHOW, $hMainGUI)

Local $hDLL = DllOpen("user32.dll")

; Loop to check for user key inputs and to disable spammers on closed windows
While 1
   ; When SHIFT is pressed
   If _IsPressed("10", $hDLL) Then
	  ; check all Hotkeys
	  For $h = 0 To UBound($g_aSpammers) - 1
		 Local $key = $g_aSpammers[$h][$g_eHotkey]
		 If $key <> "-" Then
			If _IsPressed($key, $hDLL) Then
			   _OnButtonClickSpam($h)
			EndIf
			; Wait until key is released.
			While _IsPressed($key, $hDLL)
			   Sleep(100)
			WEnd
		 EndIf
	  Next
   EndIf
   _CheckWindowsExists()
   Sleep(100); Sleep to reduce CPU usage
WEnd

Func _Exit()
	_IniSave() ; Save values to the INI file
	$aWinPos = WinGetPos($hMainGUI)
	_SaveWinPosition($aWinPos[0], $aWinPos[1])
	Exit
EndFunc   ;==>_Exit

