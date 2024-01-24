echo "powershell";
cp .\profile.ps1 $profile;

echo "windows terminal";
cp .\themes\terminal.json "$((Get-ChildItem -Path "$HOME\AppData\Local\Packages\" -Filter "Microsoft.WindowsTerminal_*").FullName)\LocalState\settings.json";

echo "neovim";
mkdir -F "$HOME\AppData\Local\nvim" | Out-Null;
Remove-Item -Path "$HOME\AppData\Local\nvim\init.lua" -Force -ErrorAction SilentlyContinue;
Remove-Item -Path "$HOME\AppData\Local\nvim\lua" -Recurse -Force -ErrorAction SilentlyContinue;
cp neovim\neovim-config.lua $HOME\AppData\Local\nvim\init.lua;
Copy-Item -Path ".\neovim" -Destination "$HOME\AppData\Local\nvim\lua" -Recurse;

echo "gitui";
mkdir -F "$HOME\.config\gitui" | Out-Null;
cp themes/gitui.ron "$HOME\.config\gitui\theme.ron";
