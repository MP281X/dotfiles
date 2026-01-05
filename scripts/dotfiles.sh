#!/bin/bash

clear

log() {
	echo ""
	printf "\033[1;33m%s\033[0m\n" "$1"
	echo ""
}

#----------------------------------------------------------------------------------------------------------------

log "neovim"

mkdir -p ~/.config/nvim
rm -r -f ~/.config/nvim/*
cp -r nvim/* ~/.config/nvim/

#----------------------------------------------------------------------------------------------------------------

log "starship"

cp terminal/starship.toml ~/.config/starship.toml

#----------------------------------------------------------------------------------------------------------------

log "bash"

cp terminal/bashrc ~/.bash_profile
cp terminal/bashrc ~/.bashrc

#----------------------------------------------------------------------------------------------------------------

log "gitui"

mkdir -p ~/.config/gitui	
cp terminal/gitui.ron ~/.config/gitui/theme.ron

#----------------------------------------------------------------------------------------------------------------

log "opencode"

mkdir -p ~/.config/opencode
rm -r -f ~/.config/opencode/agent && mkdir -p ~/.config/opencode/agent
rm -r -f ~/.config/opencode/command && mkdir -p ~/.config/opencode/command

cp opencode/opencode.json ~/.config/opencode/opencode.json
cp -r opencode/agents/* ~/.config/opencode/agent
cp -r opencode/commands/* ~/.config/opencode/command

#----------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                  │

# early exit if not inside the wsl
[ -z "$WSL_INTEROP" ] && exit 0

#----------------------------------------------------------------------------------------------------------------

log "neovim clipboard (win32yank)"
mkdir -p /mnt/c/tools && cp windows/win32yank.exe /mnt/c/tools/win32yank.exe

#----------------------------------------------------------------------------------------------------------------

log "autohotkey scripts"
windows_home=$(wslpath "C:\Users\mp281x")
cp windows/paste-wsl-path.ahk "$windows_home/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/paste-wsl-path.ahk"

#----------------------------------------------------------------------------------------------------------------

log "windows terminal"
localappdata="$(wslpath "$(cmd.exe /c 'echo %LOCALAPPDATA%' 2>/dev/null | tr -d '\r')")"
cp terminal/windows-terminal.json $localappdata/Packages/Microsoft.WindowsTerminal_*/LocalState/settings.json
cp terminal/windows-terminal.json $localappdata/Packages/Microsoft.WindowsTerminalPreview_*/LocalState/settings.json
