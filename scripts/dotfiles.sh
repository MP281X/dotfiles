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

echo "windows terminal"
appdataLocal="$(wslpath "$(cmd.exe /c 'echo %LOCALAPPDATA%' 2>/dev/null | tr -d '\r')")"
cp configs/terminal.json $appdataLocal/Packages/Microsoft.WindowsTerminal_*/LocalState/settings.json

echo "powershell"
profile="$(wslpath "$(powershell.exe -command '$profile' 2>/dev/null | tr -d '\r')")"
cp configs/profile.ps1 "$profile";

echo "vscode"
mkdir -p ~/.local/share/code-server/User
cp configs/vscode.jsonc ~/.local/share/code-server/User/settings.json

mkdir -p ~/.config/code-server
cp configs/code-server.yaml ~/.config/code-server/config.yaml

sudo systemctl restart code-server@$USER 2>/dev/null

echo "tailwind lsp"
bun i --global --silent @tailwindcss/language-server@insiders

echo "neovim clipboard"
[ -d /mnt/c ] && echo "win32yank"
[ -d /mnt/c ] && mkdir -p /mnt/c/tools/ && cp scripts/win32yank.exe /mnt/c/tools/win32yank.exe
