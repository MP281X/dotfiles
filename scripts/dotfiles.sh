echo "neovim"
mkdir -p ~/.config/nvim
rm -r -f ~/.config/nvim/*

cp -r nvim/* ~/.config/nvim/

echo "starship"
cp terminal/starship.toml ~/.config/starship.toml

echo "bash"
cp terminal/bashrc ~/.bash_profile
cp terminal/bashrc ~/.bashrc

echo "gitui"
mkdir -p ~/.config/gitui	
cp terminal/gitui.ron ~/.config/gitui/theme.ron

echo "AI"
cp ai/gemini.md ~/.gemini/GEMINI.md
cp ai/gemini.json ~/.gemini/settings.json
cp ai/opencode.json ~/.config/opencode/opencode.json

# early exit if not inside the wsl
[ -z "$WSL_INTEROP" ] && exit 0

echo "neovim clipboard (win32yank)"
mkdir -p /mnt/c/tools && cp windows/win32yank.exe /mnt/c/tools/win32yank.exe


echo "autohotkey scripts"
windows_home=$(wslpath "C:\Users\mp281x")
cp windows/paste-wsl-path.ahk "$windows_home/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/paste-wsl-path.ahk"

echo "windows terminal"
localappdata="$(wslpath "$(cmd.exe /c 'echo %LOCALAPPDATA%' 2>/dev/null | tr -d '\r')")"
cp terminal/windows-terminal.json $localappdata/Packages/Microsoft.WindowsTerminal_*/LocalState/settings.json
cp terminal/windows-terminal.json $localappdata/Packages/Microsoft.WindowsTerminalPreview_*/LocalState/settings.json
