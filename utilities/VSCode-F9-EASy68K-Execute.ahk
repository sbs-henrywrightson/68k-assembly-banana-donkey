#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_exe Code.exe")

F9::
{
    if WinExist("ahk_exe EDIT68K.exe")
    {
        WinActivate("ahk_exe EDIT68K.exe")
        WinWaitActive("ahk_exe EDIT68K.exe", , 1)

        ; -- open the banana-donkey.X68 main program file --
        ;Send("^o")
        ;WinWaitActive("Open", , 1)
        ;SendText("C:\Users\henry.dev\Code\68k-assembly\68k-assembly-banana-donkey\banana-donkey.X68")
        ;Send("{Enter}")

        Sleep(100)

        Send("{F9}")

        hwnd := WinWait("Assembler Status -", , 2)

        if hwnd
        {
            WinActivate "ahk_id " hwnd
            WinWaitActive "ahk_id " hwnd

            ;ControlFocus "TButton3", "ahk_id " hwnd
            ;ControlSend "{Enter}", "TButton3", "ahk_id " hwnd
            if ControlGetEnabled("TButton3", "ahk_id " hwnd)
                button := "TButton3"
            else
                button := "TButton2"

            ControlFocus button, "ahk_id " hwnd
            ControlSend "{Enter}", button, "ahk_id " hwnd
        }
    }
}

#HotIf