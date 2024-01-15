echo "powershell";
cp .\profile.ps1 $profile;

echo "windows terminal";
cp .\themes\terminal.json "$((Get-ChildItem -Path "$HOME\AppData\Local\Packages\" -Filter "Microsoft.WindowsTerminal_*").FullName)\LocalState\settings.json";