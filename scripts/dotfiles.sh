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

echo "vscode"
mkdir -p ~/.local/share/code-server/User
cp configs/vscode.jsonc ~/.local/share/code-server/User/settings.json

mkdir -p ~/.config/systemd/user
sudo cp configs/code-server ~/.config/systemd/user/code-server.service
systemctl --user daemon-reload
systemctl --user enable code-server
systemctl --user enable code-server@$USER 2>/dev/null

# early exit if not inside the wsl
[ -z "$WSL_INTEROP" ] && exit 0

echo "neovim clipboard (win32yank)"
mkdir -p /mnt/c/tools && cp scripts/win32yank.exe /mnt/c/tools/win32yank.exe

echo "windows terminal"
appdataLocal="$(wslpath "$(cmd.exe /c 'echo %LOCALAPPDATA%' 2>/dev/null | tr -d '\r')")"
cp configs/terminal.json $appdataLocal/Packages/Microsoft.WindowsTerminal_*/LocalState/settings.json

echo "powershell"
profile="$(wslpath "$(powershell.exe -command '$profile' 2>/dev/null | tr -d '\r')")"
cp configs/profile.ps1 "$profile";
