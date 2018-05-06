; THIS AHK SCRIPT HAS BEEN DISCONTINUED. Use SoundSwitch instead.
#SingleInstance force
; Lorin's simple audio switcher
; Make sure to disable all unwanted audio outputs
SetTitleMatchMode, 3
Pause::
	if !WinExist("Sound")
	{
		Run, mmsys.cpl
		WinWait,Sound
	}
	else
	{
		WinActivate Sound
		ControlSend,SysTabControl321,{Home} ; ensure we're on Playback tab
	}
	loop,10 ; Exits loop after 10 runs. Who has more than 10 audio outputs?
	{
		ControlSend,SysListView321,{Down}
		ControlGet,isEnabled,Enabled,,&Set Default
		if(!isEnabled)
		{
			break
		}
	}
	ControlSend,SysListView321,{Down}
	ControlGet, isEnabled, Enabled,, &Set Default
	if(!isEnabled)
	{
		ControlSend,SysListView321,{Home}
	}
	ControlClick,&Set Default
	ControlClick,OK
	;WinWaitClose
	;SoundPlay, *-1
return
