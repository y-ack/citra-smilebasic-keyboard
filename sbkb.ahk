#IfWinActive ahk_exe citra-qt.exe
;#Warn

WinActivate , ahk_exe citra-qt.exe
SetKeyDelay, -1, 1

; macOS/GNU+Linux: use "~/.config/citra-emu/config/qt-config.ini"
configDir := A_AppData . "\Citra\config\qt-config.ini"

scriptConfig := A_WorkingDir . "\sbkb.cfg"

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
file := FileOpen(scriptConfig,"r")
if IsObject(file)
{
	sLeft   = % file.ReadUInt()
	sTop    = % file.ReadUInt()
	sRight  = % file.ReadUInt()
	sBottom = % file.ReadUInt()
	file.Close()
}


global ControllerMode = 0
global SelectMode = 0
global SearchMode = 0
global DialogMode = 0
global slot = 0
global UpperCaseMode = 0 ; assume uppercase
SetCapsLockState, On



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
}

class SBKey
{
	x := 0
	y := 0
	; 0 for uppercase KB, 1 for lowercase KB
	case := 0

	__New(x,y,shift)
	{
		this.x := x
		this.y := y
		this.case := shift
	}
}
;; uppercase keyboard state
global SBKeys := []
SBKeys["!"] := new SBKey(31+(0*25), 69, 0)
SBKeys[""""]:= new SBKey(31+(1*25), 69, 0)
SBKeys["#"] := new SBKey(31+(2*25), 69, 0)
SBKeys["$"] := new SBKey(31+(3*25), 69, 0)
SBKeys["%"] := new SBKey(31+(4*25), 69, 0)
SBKeys["&"] := new SBKey(31+(5*25), 69, 0)
SBKeys["("] := new SBKey(31+(6*25), 69, 0)
SBKeys[")"] := new SBKey(31+(7*25), 69, 0)	
SBKeys["-"] := new SBKey(31+(8*25), 69, 0)
SBKeys["+"] := new SBKey(31+(9*25), 69, 0)
SBKeys["="] := new SBKey(31+(10*25), 69, 0)

SBKeys["_1"] := new SBKey(14+(0*25), 95, 0)
SBKeys["_2"] := new SBKey(14+(1*25), 95, 0)
SBKeys["_3"] := new SBKey(14+(2*25), 95, 0)
SBKeys["_4"] := new SBKey(14+(3*25), 95, 0)
SBKeys["_5"] := new SBKey(14+(4*25), 95, 0)
SBKeys["_6"] := new SBKey(14+(5*25), 95, 0)
SBKeys["_7"] := new SBKey(14+(6*25), 95, 0)
SBKeys["_8"] := new SBKey(14+(7*25), 95, 0)
SBKeys["_9"] := new SBKey(14+(8*25), 95, 0)
SBKeys["_0"] := new SBKey(14+(9*25), 95, 0)
SBKeys["["] := new SBKey(14+(10*25), 95, 0)
SBKeys["]"] := new SBKey(14+(11*25), 95, 0)

SBKeys["Q"] := new SBKey(31+(0*25), 121, 0)
SBKeys["W"] := new SBKey(31+(1*25), 121, 0)
SBKeys["E"] := new SBKey(31+(2*25), 121, 0)
SBKeys["R"] := new SBKey(31+(3*25), 121, 0)
SBKeys["T"] := new SBKey(31+(4*25), 121, 0)
SBKeys["Y"] := new SBKey(31+(5*25), 121, 0)
SBKeys["U"] := new SBKey(31+(6*25), 121, 0)
SBKeys["I"] := new SBKey(31+(7*25), 121, 0)
SBKeys["O"] := new SBKey(31+(8*25), 121, 0)
SBKeys["P"] := new SBKey(31+(9*25), 121, 0)
SBKeys["@"] := new SBKey(31+(10*25), 121, 0)
SBKeys["*"] := new SBKey(31+(11*25), 121, 0)

SBKeys["|"] := new SBKey(14+(0*25), 147, 0)
SBKeys["A"] := new SBKey(14+(1*25), 147, 0)
SBKeys["S"] := new SBKey(14+(2*25), 147, 0)
SBKeys["D"] := new SBKey(14+(3*25), 147, 0)
SBKeys["F"] := new SBKey(14+(4*25), 147, 0)
SBKeys["G"] := new SBKey(14+(5*25), 147, 0)
SBKeys["H"] := new SBKey(14+(6*25), 147, 0)
SBKeys["J"] := new SBKey(14+(7*25), 147, 0)
SBKeys["K"] := new SBKey(14+(8*25), 147, 0)
SBKeys["L"] := new SBKey(14+(9*25), 147, 0)
SBKeys[";"] := new SBKey(14+(10*25), 147, 0)
SBKeys[":"] := new SBKey(14+(11*25), 147, 0)

SBKeys["?"] := new SBKey(31+(0*25), 173, 0)
SBKeys["Z"] := new SBKey(31+(1*25), 173, 0)
SBKeys["X"] := new SBKey(31+(2*25), 173, 0)
SBKeys["C"] := new SBKey(31+(3*25), 173, 0)
SBKeys["V"] := new SBKey(31+(4*25), 173, 0)
SBKeys["B"] := new SBKey(31+(5*25), 173, 0)
SBKeys["N"] := new SBKey(31+(6*25), 173, 0)
SBKeys["M"] := new SBKey(31+(7*25), 173, 0)
SBKeys[","] := new SBKey(31+(8*25), 173, 0)
SBKeys["."] := new SBKey(31+(9*25), 173, 0)
SBKeys["'"] := new SBKey(31+(10*25), 173, 0)

SBKeys["<"] := new SBKey(197+(0*25), 199, 0)
SBKeys[">"] := new SBKey(197+(1*25), 199, 0)
SBKeys["_"] := new SBKey(197+(2*25), 199, 0)
SBKeys["/"] := new SBKey(197+(3*25), 199, 0)

;space, probably not actually used
SBKeys[" "] := new SBKey(197+(3*25), 199, 0)

;; lowercase keyboard
SBKeys["q"] := new SBKey(31+(0*25), 121, 1)
SBKeys["w"] := new SBKey(31+(1*25), 121, 1)
SBKeys["e"] := new SBKey(31+(2*25), 121, 1)
SBKeys["r"] := new SBKey(31+(3*25), 121, 1)
SBKeys["t"] := new SBKey(31+(4*25), 121, 1)
SBKeys["y"] := new SBKey(31+(5*25), 121, 1)
SBKeys["u"] := new SBKey(31+(6*25), 121, 1)
SBKeys["i"] := new SBKey(31+(7*25), 121, 1)
SBKeys["o"] := new SBKey(31+(8*25), 121, 1)
SBKeys["p"] := new SBKey(31+(9*25), 121, 1)
SBKeys["``"] := new SBKey(31+(10*25), 121, 1)

SBKeys["a"] := new SBKey(14+(1*25), 147, 1)
SBKeys["s"] := new SBKey(14+(2*25), 147, 1)
SBKeys["d"] := new SBKey(14+(3*25), 147, 1)
SBKeys["f"] := new SBKey(14+(4*25), 147, 1)
SBKeys["g"] := new SBKey(14+(5*25), 147, 1)
SBKeys["h"] := new SBKey(14+(6*25), 147, 1)
SBKeys["j"] := new SBKey(14+(7*25), 147, 1)
SBKeys["k"] := new SBKey(14+(8*25), 147, 1)
SBKeys["l"] := new SBKey(14+(9*25), 147, 1)

SBKeys["z"] := new SBKey(31+(1*25), 173, 1)
SBKeys["x"] := new SBKey(31+(2*25), 173, 1)
SBKeys["c"] := new SBKey(31+(3*25), 173, 1)
SBKeys["v"] := new SBKey(31+(4*25), 173, 1)
SBKeys["b"] := new SBKey(31+(5*25), 173, 1)
SBKeys["n"] := new SBKey(31+(6*25), 173, 1)
SBKeys["m"] := new SBKey(31+(7*25), 173, 1)

SBKeys["{"] := new SBKey(31+(6*25), 69, 1)
SBKeys["}"] := new SBKey(31+(7*25), 69, 1)
SBKeys["^"] := new SBKey(14+(7*25), 95, 1)
SBKeys["yen"] := new SBKey(14+(8*25), 95, 1)
SBKeys["~"] := new SBKey(14+(9*25), 95, 1)
SBKeys["\"] := new SBKey(197+(3*25), 199, 1)

;; dialog keyboard
SBKeys["DLG1"] := new SBKey(20+(0*25), 114, 2)
SBKeys["DLG2"] := new SBKey(20+(1*25), 114, 2)
SBKeys["DLG3"] := new SBKey(20+(2*25), 114, 2)
SBKeys["DLG4"] := new SBKey(20+(3*25), 114, 2)
SBKeys["DLG5"] := new SBKey(20+(4*25), 114, 2)
SBKeys["DLG6"] := new SBKey(20+(5*25), 114, 2)
SBKeys["DLG7"] := new SBKey(20+(6*25), 114, 2)
SBKeys["DLG8"] := new SBKey(20+(7*25), 114, 2)
SBKeys["DLG9"] := new SBKey(20+(8*25), 114, 2)
SBKeys["DLG0"] := new SBKey(20+(9*25), 114, 2)
SBKeys["DLG-"] := new SBKey(20+(10*25), 114, 2)

SBKeys["DLGQ"] := new SBKey(28+(0*25), 140, 2)
SBKeys["DLGW"] := new SBKey(28+(1*25), 140, 2)
SBKeys["DLGE"] := new SBKey(28+(2*25), 140, 2)
SBKeys["DLGR"] := new SBKey(28+(3*25), 140, 2)
SBKeys["DLGT"] := new SBKey(28+(4*25), 140, 2)
SBKeys["DLGY"] := new SBKey(28+(5*25), 140, 2)
SBKeys["DLGU"] := new SBKey(28+(6*25), 140, 2)
SBKeys["DLGI"] := new SBKey(28+(7*25), 140, 2)
SBKeys["DLGO"] := new SBKey(28+(8*25), 140, 2)
SBKeys["DLGP"] := new SBKey(28+(9*25), 140, 2)

SBKeys["DLGA"] := new SBKey(36+(0*25), 166, 2)
SBKeys["DLGS"] := new SBKey(36+(1*25), 166, 2)
SBKeys["DLGD"] := new SBKey(36+(2*25), 166, 2)
SBKeys["DLGF"] := new SBKey(36+(3*25), 166, 2)
SBKeys["DLGG"] := new SBKey(36+(4*25), 166, 2)
SBKeys["DLGH"] := new SBKey(36+(5*25), 166, 2)
SBKeys["DLGJ"] := new SBKey(36+(8*25), 166, 2)
SBKeys["DLGK"] := new SBKey(36+(7*25), 166, 2)
SBKeys["DLGL"] := new SBKey(36+(8*25), 166, 2)

SBKeys["DLGZ"] := new SBKey(44+(0*25), 192, 2)
SBKeys["DLGX"] := new SBKey(44+(1*25), 192, 2)
SBKeys["DLGC"] := new SBKey(44+(2*25), 192, 2)
SBKeys["DLGV"] := new SBKey(44+(3*25), 192, 2)
SBKeys["DLGB"] := new SBKey(44+(4*25), 192, 2)
SBKeys["DLGN"] := new SBKey(44+(5*25), 192, 2)
SBKeys["DLGM"] := new SBKey(44+(6*25), 192, 2)
SBKeys["DLG."] := new SBKey(44+(7*25), 192, 2)
SBKeys["DLG_"] := new SBKey(44+(8*25), 192, 2)

^lbutton::
	MouseGetPos x,y
	global sLeft = x
	global sTop = y
return
^rbutton::
	MouseGetPos x,y
	global sRight = x
	global sBottom = y

	; save the configuration for next time
	file := FileOpen(scriptConfig,"w")
	if IsObject(file)
	{
		file.WriteUInt(sLeft)
		file.WriteUInt(sTop)
		file.WriteUInt(sRight)
		file.WriteUInt(sBottom)
		file.Close()
	}
return
!x::
	global ControllerMode = !ControllerMode
return

DoClick(x, y, d) {
	MouseClick, L, x, y, 1, 0, D
	Sleep, d
	MouseClick, L, x, y, 1, 0, U
}

TapScreen(X, Y, d) {
	DoClick(((X/320)*(sRight-sLeft))+sLeft,((Y/240)*(sBottom-sTop))+sTop, d)
}

ShiftTap(X,Y) {
	Send, {%buttonL% down}
	TapScreen(X,Y,2)
	Send, {%buttonL% up}
}

SmartTap(character) {
	o := {}
	t := 0
	if (DialogMode) {
		o := SBKeys[Format("DLG{:U}", character)]
	} else {
		; xor
		if (RegexMatch(character, "^[A-Za-z]$") > 0) and (GetKeyState("CapsLock", "T") or GetKeyState("Shift", "P")) and !(GetKeyState("CapsLock", "T") and  GetKeyState("Shift", "P")) {
			t := 1
		}
		o := SBKeys[character]
	}

	;; not != to make unmoded keys nicer
	if (o.case == !UpperCaseMode and !t) or (RegexMatch(character, "^[A-Z]$") and UpperCaseMode) {
		ShiftTap(o.x,o.y)
	} else {
		TapScreen(o.x,o.y,0)
	}
}

!left::
slot := Max(0,slot-1)
TapScreen(93-17+(slot*17),226,0)
return
!right::
slot := Min(3,slot+1)
TapScreen(76+(slot*17),226,0)
return

esc::
	if (GetKeyState("CapsLock", "T")) {
		SetCapsLockState, Off
	}
	exitapp
return

;Keyboard mode

#If (!ControllerMode) and (!SelectMode) and WinActive("ahk_exe citra-qt.exe")

~CapsLock::
	global UpperCaseMode = !UpperCaseMode
	TapScreen(9,176,0)
return

;; RECONFIGURE IF NOT US QWERTY
;; RECONFIGURE IF NOT US QWERTY
+sc02::SmartTap("!")
+sc28::SmartTap("""")
+sc04::SmartTap("#")
+sc05::SmartTap("$")
+sc06::SmartTap("%")
+sc08::SmartTap("&")
+sc0A::SmartTap("(") 
+sc0B::SmartTap(")")
sc0C::SmartTap("-")  
+::SmartTap("+")
=::SmartTap("=")

sc02::SmartTap("_1") 
sc03::SmartTap("_2")
sc04::SmartTap("_3")
sc05::SmartTap("_4")
sc06::SmartTap("_5")
sc07::SmartTap("_6")
sc08::SmartTap("_7")
sc09::SmartTap("_8")
sc0A::SmartTap("_9")
sc0B::SmartTap("_0")
[::SmartTap("[")
+{::SmartTap("{")
]::SmartTap("]")
+}::SmartTap("}")

q::SmartTap("q")
+Q::SmartTap("Q")
w::SmartTap("w")
+W::SmartTap("W")
e::SmartTap("e")
+e::SmartTap("E")
r::SmartTap("r")
+r::SmartTap("R")
t::SmartTap("t")
+t::SmartTap("T")
y::SmartTap("y")
+y::SmartTap("Y")
u::SmartTap("u")
+u::SmartTap("U")
i::SmartTap("i")
+i::SmartTap("I")
o::SmartTap("o")
+o::SmartTap("O")
p::SmartTap("p")
+p::SmartTap("P")
+sc03::SmartTap("@")
+sc09::SmartTap("*")

+sc2B::SmartTap("|")
a::SmartTap("a")
+a::SmartTap("A")
s::SmartTap("s")
+s::SmartTap("S")
d::SmartTap("d")
+d::SmartTap("D")
f::SmartTap("f")
+f::SmartTap("F")
g::SmartTap("g")
+g::SmartTap("G")
h::SmartTap("h")
+h::SmartTap("H")
j::SmartTap("j")
+j::SmartTap("J")
k::SmartTap("k")
+k::SmartTap("K")
l::SmartTap("l")
+l::SmartTap("L")
sc27::SmartTap(";")
+sc27::SmartTap(":")

+sc35::SmartTap("?")
z::SmartTap("z")
+z::SmartTap("Z")
x::SmartTap("x")
+x::SmartTap("X")
c::SmartTap("c")
+c::SmartTap("C")
v::SmartTap("v")
+v::SmartTap("V")
b::SmartTap("b")
+b::SmartTap("B")
n::SmartTap("n")
+n::SmartTap("N")
m::SmartTap("m")
+m::SmartTap("M")
sc33::SmartTap(",")
sc34::SmartTap(".")
sc28::SmartTap("'")

+sc33::SmartTap("<")
+sc34::SmartTap(">")
+sc0C::SmartTap("_")
sc35::SmartTap("/")
sc2B::SmartTap("\")
+sc07::SmartTap("^")
+sc29::SmartTap("~")
sc29::SmartTap("``")


F1::TapScreen(32+(0*64),8,0)
F2::TapScreen(32+(1*64),8,0)
F3::TapScreen(32+(2*64),8,0)
F4::TapScreen(32+(3*64),8,0)
F5::TapScreen(32+(4*64),8,0)

del::TapScreen(311,95,0)

F6::TapScreen(22+(0*41),226,0)
F7::TapScreen(22+(1*41),226,0)

F8::TapScreen(93+(0*17),226,0)
F9::TapScreen(93+(1*17),226,0)
F10::TapScreen(93+(2*17),226,0)

space::TapScreen(143+(0*25),199,0)
+space::TapScreen(143+(0*25),199,0)

bs::
Send, {%buttonY%}
Send, %buttonY%
return
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


;; Command: comment line
^sc28::
^/::
	Send, {%buttonCLeft%}
	TapScreen(31+(10*25),173,0)
	TapScreen(143+(0*25),199,0)
return

!sc34::
	if (SearchMode) {
		TapScreen(308,25,0)
	}
	global SearchMode = 1
	TapScreen(308,25,0)
	TapScreen(14+(3*25),147,0)
	TapScreen(31+(2*25),121,0)
	TapScreen(14+(4*25),147,0)
	TapScreen(143+(0*25),199,0)
return

!w::
	SetKeyDelay, -1, 64
	Send, {%buttonCLeft%}
	TapScreen(31+(1*25),121,0) ;WHILE
	TapScreen(14+(6*25),147,0)
	TapScreen(31+(7*25),121,0)
	TapScreen(14+(9*25),147,0)
	TapScreen(31+(2*25),121,0)
	TapScreen(143+(0*25),199,0)
	Send, {%buttonA%}
	TapScreen(31+(1*25),121,0) ;WEND
	TapScreen(31+(2*25),121,0)
	TapScreen(31+(6*25),173,0)
	TapScreen(14+(3*25),147,0)
	Send, {%buttonCLeft%}
	Send, {%buttonLeft%}
	SetKeyDelay, -1, 8
return
!i::
	SetKeyDelay, -1, 64
	Send, {%buttonCLeft%}
	TapScreen(31+(7*25),121,0) ;IF
	TapScreen(14+(4*25),147,0)
	TapScreen(143+(0*25),199,0)
	Send, {%buttonCRight%}
	TapScreen(143+(0*25),199,0)
	TapScreen(31+(4*25),121,0) ;THEN
	TapScreen(14+(6*25),147,0)
	TapScreen(31+(2*25),121,0)
	TapScreen(31+(6*25),173,0)
	SetKeyDelay, -1, 8
return
!l::
	SetKeyDelay, -1, 64
	Send, {%buttonCLeft%}
	TapScreen(31+(2*25),121,0) ;ELSEIF
	TapScreen(14+(9*25),147,0)
	TapScreen(14+(2*25),147,0)
	TapScreen(31+(2*25),121,0)
	TapScreen(31+(7*25),121,0)
	TapScreen(14+(4*25),147,0)
	TapScreen(143+(0*25),199,0)
	Send, {%buttonCRight%}
	TapScreen(143+(0*25),199,0)
	TapScreen(31+(4*25),121,0) ;THEN
	TapScreen(14+(6*25),147,0)
	TapScreen(31+(2*25),121,0)
	TapScreen(31+(6*25),173,0)
	SetKeyDelay, -1, 8
return

;; Enter is mode-defined
return::
if (SearchMode) {
	TapScreen(174,8,0)
} else {
	Send, {%buttonA%}
}
return
+return::Send, {%buttonA%}


;; save/load
^s::
	global DialogMode := 1
	TapScreen(20,198,0)
	TapScreen(32,8,0)
return
^o::
	TapScreen(20,198,0)
	TapScreen(96,8,0)
return

^h::
	if (!SearchMode) { ; help menu
		TapScreen(308,45,0)
	}
	if (SearchMode) { ; toggle replace
		TapScreen(32,8,0)
	}
return

;; select/copy/undo
^space::
	global SelectMode := 1
	TapScreen(214+(0*25),225,0)
return
+left::
+right::
+down::
+up::	
if (!SelectMode) {
	TapScreen(214+(0*25),225,0)
	global SelectMode := 1
}
return
^v::TapScreen(214+(2*25),225,0)
^z::TapScreen(214+(4*25),225,0)
^y::
	TapScreen(20,198,0)
	TapScreen(214+(4*25),225,0)
	TapScreen(20,198,0)
return

; find/replace
^f::
	TapScreen(308,25,0)
	global SearchMode = !SearchMode
return
+^h::
	if (!SearchMode) {
		TapScreen(308,25,0)
		global SearchMode = !SearchMode
	}
	if (SearchMode) {
		TapScreen(32,8,0)
	}
return

; forward/reverse
^sc34::
if (SearchMode) {
	TapScreen(294,8,0)
}
return
^sc33::
if (SearchMode) {
	TapScreen(244,8,0)
}
return

;Mark (Select) Mode
#If SelectMode and WinActive("ahk_exe citra-qt.exe")
^c::
	TapScreen(214+(1*25),225,0)
	global SelectMode := 0
return
^x::
	ShiftTap(214+(1*25),225)
	global SelectMode := 0
return
^v::
	TapScreen(214+(2*25),225,0)
	global SelectMode := 0
return
bs::
	TapScreen(31+(11*25),69,0)
	global SelectMode := 0
return
del::
	TapScreen(311,95,0)
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
	TapScreen(214+(0*25),225,0)
	global SelectMode := 0
return


;Controller Mode

#If ControllerMode and WinActive("ahk_exe citra-qt.exe")
^space::
	global SelectMode := 1
	TapScreen(214+(0*25),225,0)
return



;For keyboard (save) dialogs
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

bs::TapScreen(20+(11*25),114,0)
