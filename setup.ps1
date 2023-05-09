# powershell
Copy-Item -Path "powershell.ps1" -Destination "C:\Program Files\PowerShell\7\profile.ps1"

# k9s
New-Item -ItemType Directory -Force "~\AppData\Local\k9s"
Copy-Item -Path "k9s-theme.yaml" -Destination "~\AppData\Local\k9s\skin.yml"

# windows terminal configuration
Copy-Item -Path "windows-terminal.json" -Destination "~\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# neovim
New-Item -ItemType Directory -Force "~\AppData\Local\nvim\lua"
Remove-Item -Path "~\AppData\Local\nvim\lua\*" -Recurse
Copy-Item -Path "neovim-config\*" -Destination "~\AppData\Local\nvim\lua" -Recurse
Copy-Item -Path "neovim-config.lua" "~\AppData\Local\nvim\init.lua"
