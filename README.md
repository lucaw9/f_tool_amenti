
  
# FTool by Amenti and Garu
[GitHub Link](https://github.com/lucaw9/f_tool_amenti/)

This is a tool made with [AutoIt] that automates the keystroke for the game FlyFF inspired by Ftool Extended 0.9a.
Original 1.0 Version by Garu: https://github.com/davidgaroro/ftool-by-garu

Development since then by Amenti


## Full 2.5 Zip File including just .exe-Files now available as a release!
[Click here!](https://github.com/lucaw9/f_tool_amenti/releases/tag/v2.5.0)


[AutoIt]: https://www.autoitscript.com/

<p align="center">
    <img src="https://github.com/lucaw9/f_tool_amenti/blob/master/ftool_preview.png">
</p>

## Features added since 1.0
- Press multiple keys for multiple windows at once
- Save window position
- Intervals in milliseconds
- Dark theme
- Active spammers marked in green
- Ingame skill icons to identify spammers

## Features added in 2.0
- Tabs can have individual amounts of spammers and pressers
- Settings to modify tabs and window name
- Character names instead of window names

## 2.1
- Added horizontal orientation. Adjustable in settings

## 2.2
- Added hotkeys: Use SHIFT + specified key to activate a spammer

## 2.3
- Added adjustable Rows: spammers/pressers in any grid now possible instead of just vertical/horizontal
- minor bugfixes (lists not sorted alphabetically anymore, "-" instead of " " for no f-key, new default windowname)

## 2.5
- Added features to presser:
	- Added hotkeys: same functionality as for spammer
	- Added icon: same functionality as for spammer
	- Added ability to set a skill bar to return to: set as fourth parameter in list entry. Caution: Every entry needs 4 parameters now! You need to add ",-" to all existing entries.
- Added ability to rename a spammer or presser by clicking on the label above their start/press button

## 2.6
- Hotkey base key can now be changed seperately for spammers and pressers in settings
- Improved performance for hotkeys
- Fixed window position for key prompts

## Built With
AutoIt v3.3.14.5

## How to compile 
### Install AutoIt
Download and install the AutoIt last version from website:\
[https://www.autoitscript.com/site/autoit/downloads/](https://www.autoitscript.com/site/autoit/downloads/)

### Compile scripts
[https://www.autoitscript.com/autoit3/docs/intro/compiler.htm](https://www.autoitscript.com/autoit3/docs/intro/compiler.htm)\
To compile the program and make it work you have to compile these three files:
 - FTool.au3
 - /Subfiles/Spammer.au3
 - /Subfiles/Presser.au3

## License
[MIT](./LICENSE) &copy; davidgaroro
