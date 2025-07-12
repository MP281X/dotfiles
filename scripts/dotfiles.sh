echo "neovim"
mkdir -p ~/.config/nvim/lua
rm -r -f ~/.config/nvim/*

cp neovim/neovim-config.lua ~/.config/nvim/init.lua
cp -r neovim/. ~/.config/nvim/lua/

echo "starship"
cp themes/starship.toml ~/.config/starship.toml

echo "bash"
cp configs/bashrc ~/.bash_profile
cp configs/bashrc ~/.bashrc

echo "gitui"
mkdir -p ~/.config/gitui	
cp themes/gitui.ron ~/.config/gitui/theme.ron

# early exit if not inside the wsl
[ -z "$WSL_INTEROP" ] && exit 0

echo "neovim clipboard (win32yank)"
mkdir -p /mnt/c/tools && cp scripts/win32yank.exe /mnt/c/tools/win32yank.exe


echo "autohotkey scripts"
windows_home=$(wslpath "C:\Users\mp281x")
cp configs/paste-wsl-path.ahk $windows_home/Documents/AutoHotkey/paste-wsl-path.ahk

echo "windows terminal"
localappdata="$(wslpath "$(cmd.exe /c 'echo %LOCALAPPDATA%' 2>/dev/null | tr -d '\r')")"
cp configs/terminal.json $localappdata/Packages/Microsoft.WindowsTerminal_*/LocalState/settings.json
cp configs/terminal.json $localappdata/Packages/Microsoft.WindowsTerminalPreview_*/LocalState/settings.json
