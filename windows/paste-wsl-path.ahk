#Requires AutoHotkey v2.0
!v:: {
    ; Get current clipboard content (don't copy new selection)
    originalPath := A_Clipboard

    ; Convert Windows path to WSL path
    ; Step 1: Replace backslashes with forward slashes
    wslPath := StrReplace(originalPath, "\", "/")

    ; Step 2: Convert drive letters (C:/ -> /mnt/c/)
    wslPath := RegExReplace(wslPath, "i)^([A-Z]):/", "/mnt/$L1/")

    ; Set clipboard to converted path and paste
    A_Clipboard := wslPath
    Send("^v")
}
