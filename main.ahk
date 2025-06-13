Gui, Add, Text,, Paste your text below:
Gui, Add, Edit, vInputText w600 h200
Gui, Add, Checkbox, vTypos Checked, Enable Typos 3`% rate
Gui, Show,, Realistic Burst Typing

typing := false
words := []
i := 1

F1::
    if (!typing)
    {
        ; Start or resume typing
        if (words.Length() = 0)  ; First start
        {
            Gui, Submit, NoHide
            if (InputText = "")
            {
                MsgBox, Please enter some text first.
                return
            }
            Gui, Destroy
            words := StrSplit(InputText, " ")
            i := 1
        }
        typing := true
        SetTimer, TypeBurst, 10
    }
    else
    {
        ; Pause typing
        typing := false
        SetTimer, TypeBurst, Off
    }
return

TypeBurst:
    if (!typing || i > words.Length())
    {
        typing := false
        SetTimer, TypeBurst, Off
        return
    }

    Random, burstSize, 3, 5
    burstCount := 0

    while (burstCount < burstSize && i <= words.Length() && typing)
    {
        currentWord := words[i]

        Loop, Parse, currentWord
        {
            if (!typing)
                break

            typoActive := Typos ? true : false
            if (typoActive)
            {
                Random, typoChance, 1, 100
                if (typoChance <= 3 && RegExMatch(A_LoopField, "[a-zA-Z]"))
                {
                    Random, randChar, 97, 122
                    wrongChar := Chr(randChar)
                    SendInput %wrongChar%
                    Sleep 40
                    SendInput {Backspace}
                    Sleep 40
                }
            }

            SendInput %A_LoopField%

            if A_LoopField in .,!?
                Sleep 120

            Random, delay, 25, 65
            Sleep, delay
        }

        SendInput {Space}
        i++
        burstCount++
    }

    Random, burstPause, 150, 300
    Sleep, burstPause
return

GuiClose:
    typing := false
    SetTimer, TypeBurst, Off
    ExitApp
