#include-once

Global Const $GUI_EVENT_CLOSE = -3 		; Events and messages
Global Const $CBS_DROPDOWNLIST = 0x3	; ComboBox Styles
Global Const $ES_NUMBER = 8192				; Input Styles
Global Const $WM_COMMAND = 0x0111			; Window Messages
Global Const $CBN_DROPDOWN = 7				; ComboBox Notifications
;Global Const $MB_TASKMODAL = 8192 		; Task modal
;Global Const $MB_ICONERROR = 16 			; Stop-sign icon
Global Const $GUI_SHOW = 16           ; GUI State
Global Const $GUI_HIDE = 32						; GUI State
Global Const $GUI_ENABLE = 64					; GUI State
Global Const $GUI_DISABLE = 128				;	GUI State

Func HexToKey($hex)
   If $hex = "-" Then
	  Return "-"
   EndIf
   $output = "??"
   If $hex = Hex("0x8") Then
	  $output = "BS"
   ElseIf $hex = Hex("0x09") Then
	  $output = "TB"
   ElseIf $hex = Hex("0x30") Then
	  $output = "0"
   ElseIf $hex = Hex("0x31") Then
	  $output = "1"
   ElseIf $hex = Hex("0x32") Then
	  $output = "2"
   ElseIf $hex = Hex("0x33") Then
	  $output = "3"
   ElseIf $hex = Hex("0x34") Then
	  $output = "4"
   ElseIf $hex = Hex("0x35") Then
	  $output = "5"
   ElseIf $hex = Hex("0x36") Then
	  $output = "6"
   ElseIf $hex = Hex("0x37") Then
	  $output = "7"
   ElseIf $hex = Hex("0x38") Then
	  $output = "8"
   ElseIf $hex = Hex("0x39") Then
	  $output = "9"
   ElseIf $hex = Hex("0x41") Then
	  $output = "A"
   ElseIf $hex = Hex("0x42") Then
	  $output = "B"
   ElseIf $hex = Hex("0x43") Then
	  $output = "C"
   ElseIf $hex = Hex("0x44") Then
	  $output = "D"
   ElseIf $hex = Hex("0x45") Then
	  $output = "E"
   ElseIf $hex = Hex("0x46") Then
	  $output = "F"
   ElseIf $hex = Hex("0x47") Then
	  $output = "G"
   ElseIf $hex = Hex("0x48") Then
	  $output = "H"
   ElseIf $hex = Hex("0x49") Then
	  $output = "I"
   ElseIf $hex = Hex("0x4A") Then
	  $output = "J"
   ElseIf $hex = Hex("0x4B") Then
	  $output = "K"
   ElseIf $hex = Hex("0x4C") Then
	  $output = "L"
   ElseIf $hex = Hex("0x4D") Then
	  $output = "M"
   ElseIf $hex = Hex("0x4E") Then
	  $output = "N"
   ElseIf $hex = Hex("0x4F") Then
	  $output = "O"
   ElseIf $hex = Hex("0x50") Then
	  $output = "P"
   ElseIf $hex = Hex("0x51") Then
	  $output = "Q"
   ElseIf $hex = Hex("0x52") Then
	  $output = "R"
   ElseIf $hex = Hex("0x53") Then
	  $output = "S"
   ElseIf $hex = Hex("0x54") Then
	  $output = "T"
   ElseIf $hex = Hex("0x55") Then
	  $output = "U"
   ElseIf $hex = Hex("0x56") Then
	  $output = "V"
   ElseIf $hex = Hex("0x57") Then
	  $output = "W"
   ElseIf $hex = Hex("0x58") Then
	  $output = "X"
   ElseIf $hex = Hex("0x59") Then
	  $output = "Y"
   ElseIf $hex = Hex("0x5A") Then
	  $output = "Z"
   ElseIf $hex = Hex("0x70") Then
	  $output = "F1"
   ElseIf $hex = Hex("0x71") Then
	  $output = "F2"
   ElseIf $hex = Hex("0x72") Then
	  $output = "F3"
   ElseIf $hex = Hex("0x73") Then
	  $output = "F4"
   ElseIf $hex = Hex("0x74") Then
	  $output = "F5"
   ElseIf $hex = Hex("0x75") Then
	  $output = "F6"
   ElseIf $hex = Hex("0x76") Then
	  $output = "F7"
   ElseIf $hex = Hex("0x77") Then
	  $output = "F8"
   ElseIf $hex = Hex("0x78") Then
	  $output = "F9"
   ElseIf $hex = Hex("0x79") Then
	  $output = "F10"
   ElseIf $hex = Hex("0x7A") Then
	  $output = "F11"
   ElseIf $hex = Hex("0x7B") Then
	  $output = "F12"
   EndIf
   Return $output
EndFunc
