/*
	Screen blanking script - useful for OLED displays.
	by Lorin Halpert
	
	Activate via:
		Hotkey, system tray (left click), or right click menu.
	Deactivate via:
		Moving mouse, any keyboard key

	KNOWN ISSUE - Only works on one monitor
	KNOWN ISSUE - Steals and doesn't recover window focus
*/

; Set your preferred hotkey here!
ToggleKey := "Browser_Favorites"

; Only edit beyond this point if you know what you're doing!

Hotkey, %ToggleKey%, ToggleBlanker

#SingleInstance,Force
#Persistent
#NoEnv
#Warn
SendMode Input
SetWorkingDir %A_ScriptDir%

scriptVersion := "1.0.1"
BlankerActive := false
global priorWindow
global priorControl

Menu, Tray, Tip , Screen Blanker
Menu, Tray, NoStandard
Menu, Tray, Add , Blank (key: %ToggleKey%) , ToggleBlanker
Menu, Tray, icon, Blank (key: %ToggleKey%) , shell32.dll, 26 
Menu, Tray, Add , Version %scriptVersion% , menuWebsite
Menu, Tray, icon, Version %scriptVersion% , imageres.dll, 195
Menu, Tray, Add , Reload , menuReload
Menu, Tray, icon, Reload, imageres.dll, 230
Menu, Tray, Add , Exit , menuExit
Menu, Tray, icon, Exit, imageres.dll, 85
Menu, Tray, Icon, shell32.dll, 26 ; display /w moon icon

Gui, BlankWindow:New, +LastFound +ToolWindow +AlwaysOnTop -Caption
; ToolWindow prevents blanker window from appearing in taskbar
Gui, Show, x-50 y-50 w10 h10, Screen Blanker
; Off-screen hack is needed to prevent screen flickering when script loads, as `Gui, Show, Hide` prevents hWnd acquisition.
hWnd := WinExist("Screen Blanker")
Gui, Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight%
Gui, Show, Hide
Gui, Color, black

OnMessage(0x404, "TrayIconClick")
TrayIconClick(wParam, lParam, msg, hwnd) {
	if (lParam = 0x201) ;WM_LBUTTONDOWN := 0x201
		GoSub, ToggleBlanker
}
return

ToggleBlanker:
	if (BlankerActive) {
		GoSub, DeactivateBlanker
	} else {
		global hWnd
		DllCall("ShowCursor", Int, 0)
		DllCall("User32\AnimateWindow", "Ptr", hWnd , "Int", 250, "Int", 0x000A0000) ; fade in
		Gui, BlankWindow:Show
		MouseGetPos, mx, my
		BlankerActive := true
		KeyboardHook := DllCall("SetWindowsHookEx", "int", 13, "Ptr", RegisterCallback("KeyboardAnyKey"), "Ptr", DllCall("GetModuleHandle", Str, "", "Ptr"), "Uint", 0, "Ptr")
		SetTimer, CheckMouse, 500 ;milliseconds
	}
return

DeactivateBlanker:
	SetTimer, CheckMouse, Off
	DllCall("UnhookWindowsHookEx", "Uint", KeyboardHook)
	DllCall("ShowCursor", Int, 1)
	DllCall("User32\AnimateWindow", "Ptr", hWnd, "Int", 150, "Int", 0x00090000) ; fade out
	Sleep, 160 ; Needed for fade
	Gui, BlankWindow:Show, Hide
	BlankerActive := false
return

CheckMouse:
    MouseGetPos, x, y
    if ((x != mx) or (y != my))
		GoSub, DeactivateBlanker
    mx := x, my := y
return

KeyboardAnyKey(nCode, wParam, lParam) {
	global KeyboardHook
	global BlankerActive
    Critical
    ; Any key up. keyup wParam necessary otherwise it makes the blanker reactivate immediately after pressing the hotkey when attempting to disable it
    if (nCode >= 0 and wParam = 0x101) {
		Gosub, DeactivateBlanker
    }
    return DllCall("CallNextHookEx", "Uint", KeyboardHook, "int",  nCode, "Ptr", wParam, "Ptr", lParam, "Ptr")
}

menuExit:
	ExitApp
return
menuReload:
	Reload
return
menuWebsite:
	Run,https://github.com/alystair/my-productivity-stack
return
