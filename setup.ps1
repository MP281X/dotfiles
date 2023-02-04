if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# scoop
# irm get.scoop.sh | iex
scoop install argocd
scoop install git  
scoop install k9s 
scoop install kubectl
scoop install kubeseal
scoop install mingw  
scoop install neovim
scoop install nodejs-lts
scoop install ripgrep 

# k9s
Copy-Item -Path "C:\dev\dotfiles\k9s-theme.yaml" -Destination "C:\Users\mp281x\AppData\Local\k9s\skin.yml"

# windows terminal configuration
Copy-Item -Path "C:\dev\dotfiles\windows-terminal.json" -Destination "C:\Users\mp281x\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# powershell
Copy-Item -Path "C:\dev\dotfiles\powershell.ps1" -Destination "C:\Program Files\PowerShell\7\profile.ps1"

# neovim
New-Item -ItemType Directory -Force "C:\Users\mp281x\AppData\Local\nvim\lua"
Remove-Item -Path "C:\Users\mp281x\AppData\Local\nvim\lua\*" -Recurse
Copy-Item -Path "C:\dev\dotfiles\neovim-config\*" -Destination "C:\Users\mp281x\AppData\Local\nvim\lua" -Recurse
Copy-Item -Path "C:\dev\dotfiles\neovim-config.lua" "C:\Users\mp281x\AppData\Local\nvim\init.lua"
