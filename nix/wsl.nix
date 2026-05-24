{ lib, ... }:

{
  home.activation.wslSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    terminal_settings=$(find /mnt/c/Users/mp281x/AppData/Local/Packages \
      -path '*/Microsoft.WindowsTerminal_*/LocalState/settings.json' \
      -print \
      -quit)

    if [ -z "$terminal_settings" ]; then
      echo "Windows Terminal settings.json not found" >&2
      exit 0
    fi

    cp ${../windows/windows-terminal.json} "$terminal_settings"
  '';
}
