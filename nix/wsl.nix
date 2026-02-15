{ lib, ... }:

{
  home.activation.wslSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "/mnt/c" ] || ! command -v cmd.exe >/dev/null 2>&1 || ! command -v wslpath >/dev/null 2>&1; then
      exit 0
    fi

    windows_home=$(wslpath "C:\\Users\\mp281x")
    cp ${../windows/paste-wsl-path.ahk} "$windows_home/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/paste-wsl-path.ahk"

    localappdata="$(wslpath "$(cmd.exe /c 'echo %LOCALAPPDATA%' 2>/dev/null | tr -d '\r')")"
    cp ${../windows/windows-terminal.json} $localappdata/Packages/Microsoft.WindowsTerminal_*/LocalState/settings.json
    cp ${../windows/windows-terminal.json} $localappdata/Packages/Microsoft.WindowsTerminalPreview_*/LocalState/settings.json
  '';
}
