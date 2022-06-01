#include-once

Func WM_COMMAND($hWnd, $iMsg, $wParam)
  Local $iCode = BitShift($wParam, 16) ; HiWord - this gives the message that was sent

  If $iCode <> $CBN_DROPDOWN Then Return ; Exit if is not a dropdown event

  Local $iIDFrom = BitAND($wParam, 0xFFFF) ; LoWord - this gives the control which sent the message

  ; Check if dropdown event is from select window control
  _CheckSpammers($iIDFrom)
EndFunc		;==>WM_COMMAND

Func _CheckSpammers($iIDFrom)
  Local $iSpamControl
  For $i = 0 To UBound($g_aSpammers) - 1
    $iSpamControl = $g_aSpammers[$i][$g_eSpamWindow]
    If $iIDFrom < $iSpamControl Then Return
    If $iIDFrom = $iSpamControl Then
      _GetNeuzWindows($iIDFrom)
      Return
    EndIf
   Next
EndFunc

Func _GetNeuzWindows($iIDFrom)
	$aProcessList = ProcessList("Neuz.exe") ; Get Neuz.exe list
  Local $iProccessCount = $aProcessList[0][0]

  If $iProccessCount = 0 Then Return ; Exit if there is no Neuz.exe

  Local $aWinList = WinList() ; Get windows handles list
  Local $sComboWindowsData = "|" & $g_sSelectWindow ; Use separator | at start to destroy previous list

  Local $sWindowTitle = ""
	For $i = 1 To $iProccessCount ; Loop Neuz.exe list
    For $j = 1 To $aWinList[0][0] ; Loop windows handles list
      $sWindowTitle = $aWinList[$j][0]
			; If windows have title
			If $sWindowTitle <> "" Then
				; Compare matching PIDs
				If WinGetProcess($sWindowTitle) = $aProcessList[$i][1] Then
				    $sComboWindowsData &= "|" & _getCharacterFromWindowName($sWindowTitle) ; Combo data
					ExitLoop
				EndIf
			EndIf
		Next
  Next

  ; Update select window data
	GUICtrlSetData($iIDFrom, $sComboWindowsData, $g_sSelectWindow)
EndFunc   ;==>_GetNeuzWindows


Func _CheckWindowsExists()
  ; If window title doesn't exist stop it
  Local $sWindowTitle = ""
  For $i = 0 to UBound($g_aSpammers) - 1
    $sWindowTitle = $g_aSpammers[$i][$g_eSpamWindowTitle]
    If $sWindowTitle <> "" And WinExists($sWindowTitle) = 0 Then
      _SpamStop($i)
    EndIf
  Next
EndFunc   ;==>_CheckWindowsExists

Func _getWindowNameFromCharacter($charName)
   Local $WindowString = IniRead($sFilePath, "General", "WindowName", "; - Forsaken Kingdom")
   $WindowString = StringReplace($WindowString, ";", $charName, 1, 1)
   return $WindowString
EndFunc ;==>_getWindowNameFromCharacter

Func _getCharacterFromWindowName($windowName)
   Local $WindowString = IniRead($sFilePath, "General", "WindowName", "; - Forsaken Kingdom")
   $WindowString = StringReplace($WindowString, ";", "", 1, 1) ; remove ';'
   Local $output = StringReplace($windowName, $WindowString, "", 1, 1) ; remove everything except character name
   return $output
EndFunc ;==>_getCharacterFromWindowName
