; Lorin's single instance Calculator launcher
; Replaces default calculator key functionality on keyboard
; https://github.com/alystair/my-productivity-stack

Menu, Tray, Icon , calc.exe, 1, 1
Menu, Tray, Tip, Single calculator
Menu, Tray, NoStandard
Menu, Tray, Add, &Calculator, Launch_App2
Menu, Tray, Add
Menu, Tray, Add, Exit, Exit
Menu, Tray, Default, &Calculator

Launch_App2::
IfWinNotExist Calculator
{
	Run calc.exe
	Winwait Calculator
	Winset, Alwaysontop, On, Calculator
	WinActivate Calculator
}
Else WinActivate Calculator
return

Exit:
ExitApp
