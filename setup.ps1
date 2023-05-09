set-ExecutionPolicy Unrestricted

# pnpm 
iwr https://get.pnpm.io/install.ps1 -useb | iex

# powershell
PowerShellGet\Install-Module posh-git -Scope CurrentUser -Force
Copy-Item -Path "powershell.ps1" -Destination "C:\Program Files\PowerShell\7\profile.ps1"

# k9s
New-Item -ItemType Directory -Force "~\AppData\Local\k9s"
Copy-Item -Path "k9s-theme.yaml" -Destination "~\AppData\Local\k9s\skin.yml"

# windows terminal configuration
Copy-Item -Path "windows-terminal.json" -Destination "~\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# ssh and kubectl config file
New-Item -ItemType Directory -Force "C:\Users\mp281x\.ssh"
Copy-Item -Force -Path "E:\secrets\.ssh\*" -Destination "C:\Users\mp281x\.ssh\"

New-Item -ItemType Directory -Force "C:\Users\mp281x\.kube"
Copy-Item -Force -Path "E:\secrets\config" -Destination "C:\Users\mp281x\.kube\config"