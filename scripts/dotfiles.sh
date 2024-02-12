echo "neovim"
mkdir -p ~/.config/nvim/lua
rm -r -f ~/.config/nvim/*

cp neovim/neovim-config.lua ~/.config/nvim/init.lua
cp -r neovim/. ~/.config/nvim/lua/

echo "starship"
cp themes/starship.toml ~/.config/starship.toml

echo "zsh"
cp zshrc ~/.zshrc

echo "k9s"
mkdir -p ~/.config/k9s
cp themes/k9s.yaml ~/.config/k9s/skin.yml

echo "gitui"
mkdir -p ~/.config/gitui	
cp themes/gitui.ron ~/.config/gitui/theme.ron

echo "windows terminal"
appdataLocal="$(wslpath "$(cmd.exe /c 'echo %LOCALAPPDATA%' 2>/dev/null | tr -d '\r')")"
cp ./themes/terminal.json $appdataLocal/Packages/Microsoft.WindowsTerminal_*/LocalState/settings.json

echo "powershell"
profile="$(wslpath "$(pwsh.exe -Command '$PROFILE' 2>/dev/null | tr -d '\r')")"
cp ./profile.ps1 "$profile";

[ -d /mnt/c ] && echo "win32yank"
[ -d /mnt/c ] && mkdir -p /mnt/c/tools/
[ -d /mnt/c ] && cp scripts/win32yank.exe /mnt/c/tools/win32yank.exe
