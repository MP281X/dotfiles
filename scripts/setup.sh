#!/bin/bash

clear
log() {
	echo -e ""
	echo -e "\033[1;33m$1\033[0m"
	echo -e ""
}


log "packages"
sudo apt-get update > /dev/null && sudo apt-get upgrade -y > /dev/null
sudo apt-get install -y git curl wget xz-utils unzip  > /dev/null
sudo apt-get install -y gcc g++  > /dev/null # neovim
#----------------------------------------------------------------------------------------------------------------

log "brew"
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
#----------------------------------------------------------------------------------------------------------------

log "shell"
brew install eza -q
brew install starship -q
brew install neovim -q
brew install code-server -q
#----------------------------------------------------------------------------------------------------------------

log "code-server extensions"
code() { 
	code-server --force --install-extension "$1" >/dev/null 
}

code "usernamehw.errorlens"
code "dbaeumer.vscode-eslint"
code "jolaleye.horizon-theme-vscode"
code "PKief.material-icon-theme"
code "codeandstuff.package-json-upgrade"
code "esbenp.prettier-vscode"
code "YoavBls.pretty-ts-errors"
code "svelte.svelte-vscode"
code "cmoog.sqlnotebook"
code "Orta.vscode-twoslash-queries"
code "pomdtr.excalidraw-editor"
#----------------------------------------------------------------------------------------------------------------

log "kubernetes"
brew install kubernetes-cli -q
brew install k9s -q
brew install kubeseal -q
mkdir -p ~/.kube && cp /mnt/d/secrets/config ~/.kube/config
#----------------------------------------------------------------------------------------------------------------

# log "nodejs"
# curl -fsSL https://get.pnpm.io/install.sh | sh -
# export PNPM_HOME="/home/$USER/.local/share/pnpm"
# case ":$PATH:" in *":$PNPM_HOME:"*) ;; *) export PATH="$PNPM_HOME:$PATH" ;; esac
# pnpm env use --global latest
#----------------------------------------------------------------------------------------------------------------

log "bun"
curl -fsSL https://bun.sh/install | bash
#----------------------------------------------------------------------------------------------------------------

log "docker"
brew install docker -q
# curl -fsSL https://get.docker.com | sh
# sudo usermod -aG docker $USER
#----------------------------------------------------------------------------------------------------------------

log "ssh"
mkdir -p ~/.ssh && cp /mnt/d/secrets/.ssh/id_rsa ~/.ssh/id_rsa && chmod 0400 ~/.ssh/id_rsa
#----------------------------------------------------------------------------------------------------------------

log "git"
brew install gh -q
brew install gitui -q

gh auth login --git-protocol https --hostname github.com --web --scopes read:packages
git config --global user.name $(gh api user | jq -r '.name')
git config --global user.email $(gh api user | jq -r '.email')

git config --global pull.rebase true
git config --global credential.helper cache
git config --global --replace-all core.editor nvim

git clone https://github.com/MP281X/dotfiles.git ~/dotfiles
(cd ~/dotfiles && bash ./scripts/dotfiles.sh)
#----------------------------------------------------------------------------------------------------------------

log "reboot"
wsl.exe --shutdown
