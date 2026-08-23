#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_exe EDIT68K.exe")

~F9::
{
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

#HotIf