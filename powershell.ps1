# clear the shell
Clear-Host

# import the extension
Import-Module posh-git
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History

# alias
New-Alias -Name vi -Value nvim

# change the prompt style
function prompt {

  # change the terminal windows name
  $host.ui.RawUI.WindowTitle = Get-Location

  # get the current folder name
  $path = Split-Path -Path (Get-Location) -Leaf
  Write-Host $path -NoNewline -ForegroundColor Blue

  # get the current branch
  $branch = ""
  try {$branch = git rev-parse --abbrev-ref HEAD} catch {}
  if ($branch -ne $null) {Write-Host " ($branch)" -NoNewline -ForegroundColor "red"}

  # set the input text color and the prompt ❯
  Write-Host "❯" -NoNewline -ForegroundColor Red
  Set-PSReadLineOption -colors @{ Command = "white"}

  return " "
}
