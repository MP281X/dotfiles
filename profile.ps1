Invoke-Expression (&starship init powershell);
$ENV:STARSHIP_CONFIG = "$HOME\dev\dotfiles\themes\starship.toml";

Remove-Item -Path Alias:gl -Force;
function gl { gh repo list; }
function gb { git rev-parse --abbrev-ref HEAD; }
function gc {
	param([string]$repository)
	git clone "https://github.com/$env:USERNAME/$repository";
}

Remove-Item -Path Alias:ls -Force;
function ls {
    Get-ChildItem | ForEach-Object { $_.Name }
}