Remove-Item -Path Alias:gl -Force;
function gl { gh repo list; }
function gb { git rev-parse --abbrev-ref HEAD; }
function gc {
	param([string]$repository)
	git clone "https://github.com/$env:USERNAME/$repository";
}

function prompt {
	$folder = (Get-Location).Path | Split-Path -Leaf
    Write-Host -NoNewline -ForegroundColor Blue "$folder "
    Write-Host -NoNewline -ForegroundColor Red "❯ "
    return " "
   }

Remove-Item -Path Alias:ls -Force;
function ls {
    Get-ChildItem | ForEach-Object { $_.Name }
}