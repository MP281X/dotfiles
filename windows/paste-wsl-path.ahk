#Requires AutoHotkey v2.0
!v:: {
    ; Get current clipboard content
    originalPath := A_Clipboard

    ; Use wslpath to convert Windows path to WSL path
    RunWait('wsl wslpath -u "' . originalPath . '"', , "Hide", &wslPath)

    ; Set converted path to clipboard and paste
    A_Clipboard := wslPath
    Send("^v")
}
