#IfWinActive ahk_exe citra-qt.exe

WinActivate , ahk_exe citra-qt.exe
SetKeyDelay, -1, 8

; macOS/GNU+Linux: use "~/.config/citra-emu/config/qt-config.ini"
configDir := A_AppData . "\Citra\config\qt-config.ini"

; DONE need to default to vkXX format
global buttonA = "vk50"
global buttonB = "vk4C"
global buttonY = "vk4B"
global buttonX = "vk58"
global buttonL = "vk4C"
global buttonR = "vk45"
global buttonZL = "vk31"
global buttonZR = "vk32"
global buttonUp = "vk26"
global buttonDown = "vk28"
global buttonLeft = "vk25"
global buttonRight = "vk27"
global buttonStart = "vk4E"
global buttonSelect = "vk4D"
global buttonCUp = "vk57"
global buttonCDown = "vk53"
global buttonCLeft = "vk41"
global buttonCRight = "vk44"

;store screen corners... but no way to set automatically?
global sLeft = 0
global sTop = 0
global sRight = 0
global sBottom = 0

global ControllerMode = 0
global UpperCaseMode = 1
global SelectMode = 0
global SearchMode = 0
global DialogMode = 0
global slot = 0


;unused but could maybe be used to try to guess window settings?
global winWidth = 400
global winHeight = 520
WinGetPos, winX, winY, winWidth, winHeight, ahk_exe citra-qt.exe

; read Citra configuration
FileRead, CitraConfig, configDir

readconfig:
Loop, read, %configDir%
{
	If InStr(A_LoopReadLine, "[Controls]") 
	{
		Continue
	}
	If InStr(A_LoopReadLine, "profiles\1\button_a=")
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonA)
		buttonA = % SubStr(buttonA,-1) + (3 * !!InStr(buttonA,167772))
		buttonA = % "vk" . Format("{1:X}",buttonA)
		Continue
	}
	If InStr(A_LoopReadLine, "profiles\1\button_b=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonB)
		buttonB = % "vk" . Format("{1:X}",SubStr(buttonB,6))
		Continue
	}
	If InStr(A_LoopReadLine, "profiles\1\button_x=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonX)
		buttonX = % "vk" . Format("{1:X}",SubStr(buttonX,6))
		Continue
	}
	If InStr(A_LoopReadLine, "profiles\1\button_y=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonY)
		buttonY = % "vk" . Format("{1:X}",SubStr(buttonY,6))
		Continue
	}
	If InStr(A_LoopReadLine, "profiles\1\button_up=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonUp)
		buttonUp = % SubStr(buttonUp,-1) + (3 * !!InStr(buttonUp,167772))
		buttonUp = % "vk" . Format("{1:X}",buttonUp)
		Continue
	}
	If InStr(A_LoopReadLine, "profiles\1\button_down=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonDown)
		buttonDown = % SubStr(buttonDown,-1) + (3 * !!InStr(buttonDown,167772))
		buttonDown = % "vk" . Format("{1:X}",buttonDown)
		Continue
	}
	If InStr(A_LoopReadLine, "profiles\1\button_left=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonLeft)
		buttonLeft = % SubStr(buttonLeft,-1) + (3 * !!InStr(buttonLeft,167772))
		buttonLeft = % "vk" . Format("{1:X}",buttonLeft)
		Continue
	}
	If InStr(A_LoopReadLine, "profiles\1\button_right=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonRight)
		buttonRight = % SubStr(buttonRight,-1) + (3 * !!InStr(buttonRight,167772))
		buttonRight = % "vk" . Format("{1:X}",buttonRight)
		Continue
	}
	If InStr(A_LoopReadLine, "profiles\1\button_l=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonL)
		buttonL = % "vk" . Format("{1:X}",SubStr(buttonL,6))
		Continue
	}
	If InStr(A_LoopReadLine, "profiles\1\button_r=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonR)
		buttonR = % "vk" . Format("{1:X}",SubStr(buttonR,6))
		Continue
	}
	If InStr(A_LoopReadLine, "profiles\1\button_start=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonStart)
		buttonStart = % "vk" . Format("{1:X}",SubStr(buttonStart,6))
		Continue
	}
	If InStr(A_LoopReadLine, "profiles\1\button_select=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonSelect)
		buttonSelect = % "vk" . Format("{1:X}",SubStr(buttonSelect,6))
		Continue
	}
	If InStr(A_LoopReadLine, "profiles\1\button_zl=") 
	{
		code 	:= RegExMatch(A_LoopReadLine, "code:(\d+)", buttonZL)
		buttonZL = % "vk" . Format("{1:X}",SubStr(buttonZL,6))
		Continue
	}
	If InStr(A_LoopReadLine, "profiles\1\button_zr=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonZR)
		buttonZR = % "vk" . Format("{1:X}",SubStr(buttonZR,6))
		Continue
	}

	If InStr(A_LoopReadLine, "profiles\1\circle_pad=")
	{
		code := RegExMatch(A_LoopReadLine, "right.*?code\$0(\d+)", buttonCRight)
		buttonCRight = % SubStr(buttonCRight,-1) + (3 * !!InStr(buttonCRight,167772))
		buttonCRight = % "vk" . Format("{1:X}",buttonCRight)
		code := RegExMatch(A_LoopReadLine, "left.*?code\$0(\d+)", buttonCLeft)
		buttonCLeft = % SubStr(buttonCLeft,-1) + (3 * !!InStr(buttonCLeft,167772))
		buttonCLeft = % "vk" . Format("{1:X}",buttonCLeft)
		code := RegExMatch(A_LoopReadLine, "down.*?code\$0(\d+)", buttonCDown)
		buttonCDown = % SubStr(buttonCDown,-1) + (3 * !!InStr(buttonCDown,167772))
		buttonCDown = % "vk" . Format("{1:X}",buttonCDown)
		code := RegExMatch(A_LoopReadLine, "up.*?code\$0(\d+)", buttonCUp)
		buttonCUp = % SubStr(buttonCUp,-2) + (3 * !!InStr(buttonCUp,167772))
		buttonCUp = % "vk" . Format("{1:X}",buttonCUp)
		Continue
	}
	
	If Instr(A_LoopReadLine, "profiles\1\touch_device=")
		If Instr(A_LoopReadLine, "engine:cemuhookudp")
		{
			MsgBox, Please set your touch provider as the emulator window`n(Emulation > Configure > Controls > Motion/Touch > Touch Provider)
		}

;;don't trust any of this
	If InStr(A_LoopReadLine, "custom_bottom_left=")
	{
		;global sLeft = % (SubStr(A_LoopReadLine,20))
		global sLeft = 0
		Continue
	}
	If InStr(A_LoopReadLine, "custom_bottom_top=")
	{
		global sTop = % (SubStr(A_LoopReadLine,19))
		global sTop *= ((winHeight-136)/480)
		Continue
	}
	If InStr(A_LoopReadLine, "custom_bottom_right=")
	{
		;global sRight = % (SubStr(A_LoopReadLine,21))
		global sRight = winWidth
		Continue
	}
	If InStr(A_LoopReadLine, "custom_bottom_bottom=")
	{
		global sBottom = % (SubStr(A_LoopReadLine,22))
		global sBottom *= ((winHeight-136)/480)
		Break readconfig
	}
;	Break
}

^lbutton::
MouseGetPos x,y
global sLeft = x
global sTop = y
return
^rbutton::
MouseGetPos x,y
global sRight = x
global sBottom = y
return

DoClick(x, y) {
	MouseClick, L, x, y, 1, 0, D
	Sleep, 8
	MouseClick, L, x, y, 1, 0, U
}

TapScreen(X, Y) {
DoClick(((X/320)*(sRight-sLeft))+sLeft,((Y/240)*(sBottom-sTop))+sTop)
}

ShiftTap(X,Y) {
	Send, {%buttonL% down}
	TapScreen(X,Y)
	Send, {%buttonL% up}
}

!x::
global ControllerMode = !ControllerMode
return
CapsLock::
global UpperCaseMode = !UpperCaseMode
TapScreen(9,176)
return

!left::
slot := Max(0,slot-1)
TapScreen(93-17+(slot*17),226)
return
!right::
slot := Min(3,slot+1)
TapScreen(76+(slot*17),226)
return

esc::exitapp

;Keyboard mode

#If (!ControllerMode) and (!DialogMode) and (!SelectMode) and WinActive("ahk_exe citra-qt.exe")

+1::TapScreen(31+(0*25),69)
+sc28::TapScreen(31+(1*25),69)
+3::TapScreen(31+(2*25),69)
+4::TapScreen(31+(3*25),69)
+5::TapScreen(31+(4*25),69)
+7::TapScreen(31+(5*25),69)
(::TapScreen(31+(6*25),69)
)::TapScreen(31+(7*25),69)
-::TapScreen(31+(8*25),69)
+::TapScreen(31+(9*25),69)
=::TapScreen(31+(10*25),69)

1::TapScreen(14+(0*25),95)
2::TapScreen(14+(1*25),95)
3::TapScreen(14+(2*25),95)
4::TapScreen(14+(3*25),95)
5::TapScreen(14+(4*25),95)
6::TapScreen(14+(5*25),95)
7::TapScreen(14+(6*25),95)
8::TapScreen(14+(7*25),95)
9::TapScreen(14+(8*25),95)
0::TapScreen(14+(9*25),95)
[::TapScreen(14+(10*25),95)
]::TapScreen(14+(11*25),95)

q::TapScreen(31+(0*25),121)
+q::ShiftTap(31+(0*25),121)
w::TapScreen(31+(1*25),121)
+w::ShiftTap(31+(1*25),121)
e::TapScreen(31+(2*25),121)
+e::ShiftTap(31+(2*25),121)
r::TapScreen(31+(3*25),121)
+r::ShiftTap(31+(3*25),121)
t::TapScreen(31+(4*25),121)
+t::ShiftTap(31+(4*25),121)
y::TapScreen(31+(5*25),121)
+y::ShiftTap(31+(5*25),121)
u::TapScreen(31+(6*25),121)
+u::ShiftTap(31+(6*25),121)
i::TapScreen(31+(7*25),121)
+i::ShiftTap(31+(7*25),121)
o::TapScreen(31+(8*25),121)
+o::ShiftTap(31+(8*25),121)
p::TapScreen(31+(9*25),121)
+p::ShiftTap(31+(9*25),121)
@::TapScreen(31+(10*25),121)
*::TapScreen(31+(11*25),121)

|::TapScreen(14+(0*25),147)
a::TapScreen(14+(1*25),147)
+a::ShiftTap(14+(1*25),147)
s::TapScreen(14+(2*25),147)
+s::ShiftTap(14+(2*25),147)
d::TapScreen(14+(3*25),147)
+d::ShiftTap(14+(3*25),147)
f::TapScreen(14+(4*25),147)
+f::ShiftTap(14+(4*25),147)
g::TapScreen(14+(5*25),147)
+g::ShiftTap(14+(5*25),147)
h::TapScreen(14+(6*25),147)
+h::ShiftTap(14+(6*25),147)
j::TapScreen(14+(7*25),147)
+j::ShiftTap(14+(7*25),147)
k::TapScreen(14+(8*25),147)
+k::ShiftTap(14+(8*25),147)
l::TapScreen(14+(9*25),147)
+l::ShiftTap(14+(9*25),147)
sc27::TapScreen(14+(10*25),147)
+sc27::TapScreen(14+(11*25),147)

?::TapScreen(31+(0*25),173)
z::TapScreen(31+(1*25),173)
+z::ShiftTap(31+(1*25),173)
x::TapScreen(31+(2*25),173)
+x::ShiftTap(31+(2*25),173)
c::TapScreen(31+(3*25),173)
+c::ShiftTap(31+(3*25),173)
v::TapScreen(31+(4*25),173)
+v::ShiftTap(31+(4*25),173)
b::TapScreen(31+(5*25),173)
+b::ShiftTap(31+(5*25),173)
n::TapScreen(31+(6*25),173)
+n::ShiftTap(31+(6*25),173)
m::TapScreen(31+(7*25),173)
+m::ShiftTap(31+(7*25),173)
sc33::TapScreen(31+(8*25),173)
sc34::TapScreen(31+(9*25),173)
sc28::TapScreen(31+(10*25),173)

+sc33::TapScreen(197+(0*25),199)
+sc34::TapScreen(197+(1*25),199)
_::TapScreen(197+(2*25),199)
/::TapScreen(197+(3*25),199)


F1::TapScreen(32+(0*64),8)
F2::TapScreen(32+(1*64),8)
F3::TapScreen(32+(2*64),8)
F4::TapScreen(32+(3*64),8)
F5::TapScreen(32+(4*64),8)

del::TapScreen(311,95)

F6::TapScreen(22+(0*41),226)
F7::TapScreen(22+(1*41),226)

F8::TapScreen(93+(0*17),226)
F9::TapScreen(93+(1*17),226)
F10::TapScreen(93+(2*17),226)

space::TapScreen(143+(0*25),199)
+space::TapScreen(143+(0*25),199)

bs::Send, {%buttonY%}
+bs::Send, {%buttonY%}
^bs::
	Send, {%buttonL% down}
	Send, {%buttonY%}
	Send, {%buttonL% up}
return

; large motion
^left::
home::
	Send, {%buttonCLeft%}
return
^right::
end::
	Send, {%buttonCRight%}
return
^up::
pgup::
	Send, {%buttonCUp%}
return
^down::
pgdn::
	Send, {%buttonCDown%}
return


^sc28::
^/::
	Send, {%buttonCLeft%}
	TapScreen(31+(10*25),173)
	;TapScreen(143+(0*25),199)
return

!sc34::
	if (SearchMode) {
		TapScreen(308,25)
	}
	global SearchMode = 1
	TapScreen(308,25)
	TapScreen(14+(3*25),147)
	TapScreen(31+(2*25),121)
	TapScreen(14+(4*25),147)
	TapScreen(143+(0*25),199)
return

!w::
	SetKeyDelay, -1, 64
	Send, {%buttonCLeft%}
	TapScreen(31+(1*25),121) ;WHILE
	TapScreen(14+(6*25),147)
	TapScreen(31+(7*25),121)
	TapScreen(14+(9*25),147)
	TapScreen(31+(2*25),121)
	TapScreen(143+(0*25),199)
	Send, {%buttonA%}
	TapScreen(31+(1*25),121) ;WEND
	TapScreen(31+(2*25),121)
	TapScreen(31+(6*25),173)
	TapScreen(14+(3*25),147)
	Send, {%buttonCLeft%}
	Send, {%buttonLeft%}
	SetKeyDelay, -1, 8
return
!i::
	SetKeyDelay, -1, 64
	Send, {%buttonCLeft%}
	TapScreen(31+(7*25),121) ;IF
	TapScreen(14+(4*25),147)
	TapScreen(143+(0*25),199)
	Send, {%buttonCRight%}
	TapScreen(143+(0*25),199)
	TapScreen(31+(4*25),121) ;THEN
	TapScreen(14+(6*25),147)
	TapScreen(31+(2*25),121)
	TapScreen(31+(6*25),173)
	SetKeyDelay, -1, 8
return
!l::
	SetKeyDelay, -1, 64
	Send, {%buttonCLeft%}
	TapScreen(31+(2*25),121) ;ELSEIF
	TapScreen(14+(9*25),147)
	TapScreen(14+(2*25),147)
	TapScreen(31+(2*25),121)
	TapScreen(31+(7*25),121)
	TapScreen(14+(4*25),147)
	TapScreen(143+(0*25),199)
	Send, {%buttonCRight%}
	TapScreen(143+(0*25),199)
	TapScreen(31+(4*25),121) ;THEN
	TapScreen(14+(6*25),147)
	TapScreen(31+(2*25),121)
	TapScreen(31+(6*25),173)
	SetKeyDelay, -1, 8
return
	
return::
if (SearchMode) {
	TapScreen(174,8)
} else {
	;TapScreen(31+(11*25),173)
	Send, {%buttonA%}
}
return
+return::Send, {%buttonA%}


;save/load
^s::
	global DialogMode := 1
	TapScreen(20,198)
	TapScreen(32,8)
return
^o::
	TapScreen(20,198)
	TapScreen(96,8)
return

^h::
	if (!SearchMode) { ; help menu
		TapScreen(308,45)
	}
	if (SearchMode) { ; toggle replace
		TapScreen(32,8)
	}
return

; select/copy/undo
^space::
	global SelectMode := 1
	TapScreen(214+(0*25),225)
return
+left::
+right::
+down::
+up::	
if (!SelectMode) {
	TapScreen(214+(0*25),225)
	global SelectMode := 1
}
return
^v::TapScreen(214+(2*25),225)
^z::TapScreen(214+(4*25),225)
^y::
	TapScreen(20,198)
	TapScreen(214+(4*25),225)
	TapScreen(20,198)
return

; find/replace
^f::
	TapScreen(308,25)
	global SearchMode = !SearchMode
return
+^h::
	if (!SearchMode) {
		TapScreen(308,25)
		global SearchMode = !SearchMode
	}
	if (SearchMode) {
		TapScreen(32,8)
	}
return

; forward/reverse
^sc34::
if (SearchMode) {
	TapScreen(294,8)
}
return
^sc33::
if (SearchMode) {
	TapScreen(244,8)
}
return

;Mark (Select) Mode
#If SelectMode and WinActive("ahk_exe citra-qt.exe")
^c::
	TapScreen(214+(1*25),225)
	global SelectMode := 0
return
^x::
	TapScreen(20,198)
	TapScreen(214+(1*25),225)
	TapScreen(20,198)
	global SelectMode := 0
return
^v::
	TapScreen(214+(2*25),225)
	global SelectMode := 0
return
bs::
	TapScreen(31+(11*25),69)
	global SelectMode := 0
return
del::
	TapScreen(311,95)
	global SelectMode := 0
return


;; wtf
+^left::
^left::
+home::
home::
	Send, {%buttonCLeft%}
return
+^right::
^right::
+end::
end::
	Send, {%buttonCRight%}
return
+^up::
^up::
+pgup::
pgup::
	Send, {%buttonCUp%}
return
+^down::
^down::
+pgdn::
pgdn::
	Send, {%buttonCDown%}
return
+left::Send, {%buttonLeft%}
+right::Send, {%buttonRight%}
+up::Send, {%buttonUp%}
+down::Send, {%buttonDown%}


a:: 
b::
c::
d::
e::
f::
g::
h::
i::
j::
k::
l::
m::
n::
o::
p:: 
q:: 
r::
s::
t::
u::
v::
w:: 
x::
y:: 
z::
_::
@::
space::
	global SelectMode := 0
return

^space::
	TapScreen(214+(0*25),225)
	global SelectMode := 0
return


;Controller Mode

#If ControllerMode and WinActive("ahk_exe citra-qt.exe")
^space::
	global SelectMode := 1
	TapScreen(214+(0*25),225)
return



;For keyboard (save/load) dialogs
#If DialogMode and WinActive("ahk_exe citra-qt.exe")
^c::
	DialogMode = 0
	Send, {%buttonB%}
return
return::
	Send, {%buttonA%}
	DialogMode += 1
	if (DialogMode = 4) {
		DialogMode = 0
		global MaybeDialog = 1
	}
return

1::TapScreen(20+(0*25),114)
2::TapScreen(20+(1*25),114)
3::TapScreen(20+(2*25),114)
4::TapScreen(20+(3*25),114)
5::TapScreen(20+(4*25),114)
6::TapScreen(20+(5*25),114)
7::TapScreen(20+(6*25),114)
8::TapScreen(20+(7*25),114)
9::TapScreen(20+(8*25),114)
0::TapScreen(20+(9*25),114)
-::TapScreen(20+(10*25),114)
bs::TapScreen(20+(11*25),114)

q::TapScreen(28+(0*25),140)
w::TapScreen(28+(1*25),140)
e::TapScreen(28+(2*25),140)
r::TapScreen(28+(3*25),140)
t::TapScreen(28+(4*25),140)
y::TapScreen(28+(5*25),140)
u::TapScreen(28+(6*25),140)
i::TapScreen(28+(7*25),140)
o::TapScreen(28+(8*25),140)
p::TapScreen(28+(9*25),140)

a::TapScreen(36+(0*25),166)
s::TapScreen(36+(1*25),166)
d::TapScreen(36+(2*25),166)
f::TapScreen(36+(3*25),166)
g::TapScreen(36+(4*25),166)
h::TapScreen(36+(5*25),166)
j::TapScreen(36+(6*25),166)
k::TapScreen(36+(7*25),166)
l::TapScreen(36+(8*25),166)

z::TapScreen(44+(0*25),192)
x::TapScreen(44+(1*25),192)
c::TapScreen(44+(2*25),192)
v::TapScreen(44+(3*25),192)
b::TapScreen(44+(4*25),192)
n::TapScreen(44+(5*25),192)
m::TapScreen(44+(6*25),192)
sc34::TapScreen(44+(7*25),192)
_::TapScreen(44+(8*25),192)

