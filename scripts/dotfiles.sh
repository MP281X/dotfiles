#!/bin/bash

clear

log() {
	echo ""
	printf "\033[1;33m%s\033[0m\n" "$1"
	echo ""
}

#----------------------------------------------------------------------------------------------------------------

log "zsh"

cp shell/zshrc ~/.zshrc
touch ~/.hushlogin

#----------------------------------------------------------------------------------------------------------------

log "starship"

mkdir -p ~/.config
cp shell/starship.toml ~/.config/starship.toml

#----------------------------------------------------------------------------------------------------------------

log "zed"

mkdir -p ~/.config/zed
cp zed/settings.json ~/.config/zed/settings.json

#----------------------------------------------------------------------------------------------------------------

log "claude"

mkdir -p ~/.claude/commands
cp .claude/settings.local.json ~/.claude/settings.json
cp .claude/commands/*.md ~/.claude/commands/
