{ lib, ... }:

{
  # WSL-specific configurations
  # These activation scripts copy necessary files to Windows for integration

  # Copy win32yank to Windows for clipboard integration
  home.activation.wslClipboard = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -d "/mnt/c" ]; then
      $DRY_RUN_CMD mkdir -p /mnt/c/tools
      $DRY_RUN_CMD cp ${../windows/win32yank.exe} /mnt/c/tools/win32yank.exe 2>/dev/null || true
    fi
  '';

  # Copy AutoHotkey script to Windows startup
  home.activation.wslAutoHotkey = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -d "/mnt/c" ] && command -v wslpath >/dev/null 2>&1; then
      windows_home=$(wslpath "C:\\Users\\$USER" 2>/dev/null || echo "")
      if [ -n "$windows_home" ] && [ -d "$windows_home" ]; then
        startup_dir="$windows_home/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"
        $DRY_RUN_CMD mkdir -p "$startup_dir" 2>/dev/null || true
        $DRY_RUN_CMD cp ${../windows/paste-wsl-path.ahk} "$startup_dir/paste-wsl-path.ahk" 2>/dev/null || true
      fi
    fi
  '';

  # Copy Windows Terminal settings
  home.activation.windowsTerminal = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -d "/mnt/c" ] && command -v wslpath >/dev/null 2>&1 && command -v cmd.exe >/dev/null 2>&1; then
      localappdata=$(wslpath "$(cmd.exe /c 'echo %LOCALAPPDATA%' 2>/dev/null | tr -d '\r')" 2>/dev/null || echo "")
      if [ -n "$localappdata" ] && [ -d "$localappdata" ]; then
        for wt_dir in "$localappdata"/Packages/Microsoft.WindowsTerminal_*/LocalState "$localappdata"/Packages/Microsoft.WindowsTerminalPreview_*/LocalState; do
          if [ -d "$wt_dir" ]; then
            $DRY_RUN_CMD cp ${../config/windows-terminal.json} "$wt_dir/settings.json" 2>/dev/null || true
          fi
        done
      fi
    fi
  '';
}
