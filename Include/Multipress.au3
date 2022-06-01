#include-once


Func _OnButtonClickMultiPress()
  ; Get presser index
  Local $iPressIndex = GUICtrlRead(@GUI_CtrlId - 2)
  ; Press
  _MultiPressButtonFlash()
  _MultiPress($iPressIndex)
EndFunc   ;==>_OnButtonClick

Func _MultiPressButtonFlash()
  ; Get CTRL index
  Local $iIndex = GUICtrlRead(@GUI_CtrlId - 2)
  ; Press
  Local $iButtonCtrlId = $g_aMultiPressers[$iIndex][$g_eSpamButton]
  GUICtrlSetBkColor($iButtonCtrlId, $COLOR_GREEN)
  Sleep(50)
  GUICtrlSetBkColor($iButtonCtrlId, $COLOR_DARK1)
EndFunc   ;==>_MultiPressButtonFlash

Local $text = "Specify a comma-separated list containing skillbar (- or 1-8), F-key (F1-9 or z), and character name." & @CRLF & "Example 1: 1,F2,Test. Example 2: -,z,Test"

Func _OnButtonClickAdd()
  ; Get index
  Local $iIndex = GUICtrlRead(@GUI_CtrlId - 5) ; ID des MultiPressers
  Local $input = InputBox("Add action", $text, "", "", 300, 160)
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
	  Local $input = InputBox("Edit action", $text, $iSelected, "", 300, 160)
	  if $input <> "" Then
		 $g_aMultiPressers[$iIndex][4] = StringReplace($g_aMultiPressers[$iIndex][4], $iSelected, $input, 1, 1)
		 _UpdateContent($iIndex)
	  EndIf
   EndIf
EndFunc   ;==>_OnButtonClickEdit

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
	  If (UBound($list) <> 3) Or (StringLen($list[2]) < 4) Or (StringLen($list[0]) > 1) Or (StringLen($list[1]) > 2) Then
		 MsgBox($MB_TASKMODAL + $MB_ICONERROR, "Validation Error", "Invalid Input for Presser.")
		 Return
	  EndIf
	  $sWindow = _getWindowNameFromCharacter($list[2])
	  $sSkill = $list[0]
	  $sFKey = $list[1]

	  ; Check if window still exists
	  If WinExists($sWindow) <> 0 Then
		 If $sFKey = "" And $sSkill = "" Then
			MsgBox($MB_TASKMODAL + $MB_ICONERROR, "Validation Error", "Select Key or Skill Bar for " & $sWindow & ".")
			Return
		 EndIf
		 ; Get flyff window handle
		 Local $hWindow = WinGetHandle($sWindow)
		 ; Run script with params: main window PID, flyff window handle, fkey and skill bar
		 Local $sParams = $iMainPID & ' "' & $hWindow & '" "' & $sFKey & '" "' & $sSkill & '"'
		 Run($sPresserFile & ' ' & $sParams)
	  EndIf
  Next

EndFunc   ;==>_MultiPress