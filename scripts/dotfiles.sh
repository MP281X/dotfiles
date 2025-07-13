echo "neovim"
mkdir -p ~/.config/nvim/lua
rm -r -f ~/.config/nvim/*

cp nvim/neovim-config.lua ~/.config/nvim/init.lua
cp -r nvim/. ~/.config/nvim/lua/

echo "starship"
cp terminal/starship.toml ~/.config/starship.toml

echo "bash"
cp terminal/bashrc ~/.bash_profile
cp terminal/bashrc ~/.bashrc

echo "gitui"
mkdir -p ~/.config/gitui	
cp terminal/gitui.ron ~/.config/gitui/theme.ron

# early exit if not inside the wsl
[ -z "$WSL_INTEROP" ] && exit 0

echo "neovim clipboard (win32yank)"
mkdir -p /mnt/c/tools && cp windows/win32yank.exe /mnt/c/tools/win32yank.exe


echo "autohotkey scripts"
windows_home=$(wslpath "C:\Users\mp281x")
cp windows/paste-wsl-path.ahk $windows_home/Documents/AutoHotkey/paste-wsl-path.ahk

echo "windows terminal"
localappdata="$(wslpath "$(cmd.exe /c 'echo %LOCALAPPDATA%' 2>/dev/null | tr -d '\r')")"
cp terminal/windows-terminal.json $localappdata/Packages/Microsoft.WindowsTerminal_*/LocalState/settings.json
cp terminal/windows-terminal.json $localappdata/Packages/Microsoft.WindowsTerminalPreview_*/LocalState/settings.json
