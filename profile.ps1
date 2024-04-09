function prompt {
	$folder = (Get-Location).Path | Split-Path -Leaf
    Write-Host -NoNewline -ForegroundColor Blue "$folder "
    Write-Host -NoNewline -ForegroundColor Red ">"
    return " "
   }

Remove-Item -Path Alias:ls -Force;
function ls {
    Get-ChildItem | ForEach-Object { $_.Name }
}
