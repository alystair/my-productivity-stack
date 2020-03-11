; Lorin's single instance Calculator launcher
; Replaces default calculator key functionality on keyboard
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
