#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\Icons\AutoIt_Main_v11_256x256_RGB-A.ico
#AutoIt3Wrapper_Res_Description=Presser
#AutoIt3Wrapper_Res_Fileversion=1.0
#AutoIt3Wrapper_Res_ProductName=FTool by Amenti
#AutoIt3Wrapper_Res_ProductVersion=1.0
#AutoIt3Wrapper_Res_LegalCopyright=MIT © davidgaroro
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;;; KEYS
; 13 = ENTER, 32 = SPACE, 27 = ESC, 90 = z, 83 = s, 49 = 1, 50 = 2 ..., 112 = F1, 113 = F2 ...


; Disable tray menu
#NoTrayIcon

; Check if params are less then 5
If $CmdLine[0] <> 5 Then
	Exit
EndIf

; Get inputs data
Local $iMainPID = $CmdLine[1]
Local $hWindow = $CmdLine[2]
Local $sFKey = $CmdLine[3]
Local $sSkill = $CmdLine[4]
Local $sReturnSkill = $CmdLine[5]

; Check if fkey, skill and return skill have been selected
Local $bFKey = ($sFKey <> "-")
Local $bSkill = ($sSkill <> "-")
Local $bReturnSkill = ($sReturnSkill <> "-")

; Delete F character from F-Keys to get the number
If ($bFKey = True) And ($sFKey <> "z") Then
   $sFKey = StringTrimLeft($sFKey, 1)
EndIf

Func _Press()
  	If $bSkill = True Then
		; Send Skill number to flyff window
	    _SendKey(48 + $sSkill)
	    Sleep(150)
	EndIf
	If $bFKey = True Then
		; Send F-key to flyff window
		If $sFKey = "z" Then
			_SendKey(90) ; 90 is z
	    Else
		   _SendKey(111 + $sFKey)
	    EndIf
	 EndIf
	 If $bReturnSkill = True Then
		; Send Return skill bar to flyff window
	    Sleep(150)
	    _SendKey(48 + $sReturnSkill)
	 EndIf
EndFunc   ;==>_Press

Func _SendKey($iKey)
  DllCall("Functions.dll", "none", "fnPostMessage", "HWnd", $hWindow, "long", 256, "long", $iKey, "long", 0)
EndFunc   ;==>_SendKey

_Press()


