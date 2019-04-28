#IfWinActive ahk_exe citra-qt.exe
#Warn

; macOS/GNU+Linux: use "~/.config/citra-emu/config/qt-config.ini"
configDir := A_AppData . "\Citra\config\qt-config.ini"

global buttonA = "A"
global buttonB = "S"
global buttonY = "X"
global buttonX = "Z"
global buttonL = "Q"
global buttonR = "W"
global buttonZL = "1"
global buttonZR = "2"
global buttonUp = "T"
global buttonDown = "G"
global buttonLeft = "F"
global buttonRight = "H"
global buttonStart = "N"
global buttonSelect = "M"
global sLeft = 0
global sTop = 0
global sRight = 0
global sBottom = 0

global ControllerMode = 0
global UpperCaseMode = 0
global SelectMode = 0
global SearchMode = 0
global DialogMode = 0
global slot = 0

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
	If InStr(A_LoopReadLine, "button_a=")
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonA)
		buttonA = % Chr(SubStr(buttonA,6))
		Continue
	}
	If InStr(A_LoopReadLine, "button_b=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonB)
		buttonB = % Chr(SubStr(buttonB,6))
		Continue
	}
	If InStr(A_LoopReadLine, "button_x=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonX)
		buttonX = % Chr(SubStr(buttonX,6))
		Continue
	}
	If InStr(A_LoopReadLine, "button_y=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonY)
		buttonY = % Chr(SubStr(buttonY,6))
		Continue
	}
	If InStr(A_LoopReadLine, "button_up=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonUp)
		buttonUp = % Chr(SubStr(buttonUp,6))
		Continue
	}
	If InStr(A_LoopReadLine, "button_down=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonDown)
		buttonDown = % Chr(SubStr(buttonDown,6))
		Continue
	}
	If InStr(A_LoopReadLine, "button_left=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonLeft)
		buttonLeft = % Chr(SubStr(buttonLeft,6)+32)
		Continue
	}
	If InStr(A_LoopReadLine, "button_right=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonRight)
		buttonRight = % Chr(SubStr(buttonRight,6))
		Continue
	}
	If InStr(A_LoopReadLine, "button_l=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonL)
		buttonL = % Chr(SubStr(buttonL,6))
		Continue
	}
	If InStr(A_LoopReadLine, "button_r=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonR)
		buttonR = % Chr(SubStr(buttonR,6))
		Continue
	}
	If InStr(A_LoopReadLine, "button_start=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonStart)
		buttonStart = % Chr(SubStr(buttonStart,6))
		Continue
	}
	If InStr(A_LoopReadLine, "button_select=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonSelect)
		buttonSelect = % Chr(SubStr(buttonSelect,6))
		Continue
	}
	If InStr(A_LoopReadLine, "button_zl=") 
	{
		code 	:= RegExMatch(A_LoopReadLine, "code:(\d+)", buttonZL)
		buttonZL = % Chr(SubStr(buttonZL,6))
		Continue
	}
	If InStr(A_LoopReadLine, "button_zr=") 
	{
		code := RegExMatch(A_LoopReadLine, "code:(\d+)", buttonZR)
		buttonZR = % Chr(SubStr(buttonZR,6))
		Continue
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

!x::
global ControllerMode = !ControllerMode
return
CapsLock::
global UpperCaseMode = !UpperCaseMode
TapScreen(9,176)
return

^left::
slot := Max(0,slot-1)
TapScreen(93-17+(slot*17),226)
return
^right::
slot := Min(3,slot+1)
TapScreen(76+(slot*17),226)
return

esc::exitapp

;Keyboard mode

#If (!ControllerMode) and (!DialogMode) and WinActive("ahk_exe citra-qt.exe")

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
w::TapScreen(31+(1*25),121)
e::TapScreen(31+(2*25),121)
r::TapScreen(31+(3*25),121)
t::TapScreen(31+(4*25),121)
y::TapScreen(31+(5*25),121)
u::TapScreen(31+(6*25),121)
i::TapScreen(31+(7*25),121)
o::TapScreen(31+(8*25),121)
p::TapScreen(31+(9*25),121)
@::TapScreen(31+(10*25),121)
*::TapScreen(31+(11*25),121)

|::TapScreen(14+(0*25),147)
a::TapScreen(14+(1*25),147)
s::TapScreen(14+(2*25),147)
d::TapScreen(14+(3*25),147)
f::TapScreen(14+(4*25),147)
g::TapScreen(14+(5*25),147)
h::TapScreen(14+(6*25),147)
j::TapScreen(14+(7*25),147)
k::TapScreen(14+(8*25),147)
l::TapScreen(14+(9*25),147)
sc27::TapScreen(14+(10*25),147)
+sc27::TapScreen(14+(11*25),147)

?::TapScreen(31+(0*25),173)
z::TapScreen(31+(1*25),173)
x::TapScreen(31+(2*25),173)
c::TapScreen(31+(3*25),173)
v::TapScreen(31+(4*25),173)
b::TapScreen(31+(5*25),173)
n::TapScreen(31+(6*25),173)
m::TapScreen(31+(7*25),173)
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

bs::TapScreen(31+(11*25),69)
return::
if (MaybeDialog) {
	TapScreen(295,212)
	global MaybeDialog = 0
} else {
	if (SearchMode) {
		TapScreen(174,8)
	} else {
		TapScreen(31+(11*25),173)
	}
}
return


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

; select/copy/undo
^space::
shift::
	global SelectMode := 1
	TapScreen(214+(0*25),225)
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
^h::
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
	global SelectMode := 0
return

^space::
shift::
	TapScreen(214+(0*25),225)
	global SelectMode := 0
return


;Controller Mode

#If ControllerMode and WinActive("ahk_exe citra-qt.exe")

shift::
	global SelectMode := 1
	TapScreen(214+(0*25),225)
return
;none of this actually does anything
Hotkey, %buttonUp%, Send %buttonUp%
HotKey, %buttonDown%, Send %buttonDown%
HotKey, %buttonLeft%, Send %buttonLeft%
HotKey, %buttonRight%, Send %buttonRight%
HotKey, %buttonA%, Send %buttonA%
HotKey, %buttonB%, Send %buttonB%
HotKey, %buttonX%, Send %buttonX%
HotKey, %buttonY%, Send %buttonY%
HotKey, %buttonL%, Send %buttonL%
HotKey, %buttonR%, Send %buttonR%


;For keyboard (save/load) dialogs
#If DialogMode and WinActive("ahk_exe citra-qt.exe")
^c::
	DialogMode = 0
	TapScreen(42,220)
return
return::
	TapScreen(282,220)
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
