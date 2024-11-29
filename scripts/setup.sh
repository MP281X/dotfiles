#!/bin/bash

clear

log() {
	echo -e ""
	echo -e "\033[1;33m$1\033[0m"
	echo -e ""
}

brewInstall() {
	export HOMEBREW_NO_ENV_HINTS=1
	export HOMEBREW_NO_AUTO_UPDATE=1
	echo "[brew] $1"
	brew install $1 -q 1>/dev/null
}

code() { 
	echo "[code-server] $1"
	code-server --force --install-extension "$1" >/dev/null 
}
#----------------------------------------------------------------------------------------------------------------

log "packages"

sudo apt-get update > /dev/null && sudo apt-get upgrade -y > /dev/null
sudo apt-get install -y git curl wget xz-utils unzip jq > /dev/null
sudo apt-get install -y gcc g++ ripgrep > /dev/null # neovim
#----------------------------------------------------------------------------------------------------------------

log "mount usb"

sudo mkdir -p /mnt/d
sudo mount -t drvfs d: /mnt/d -o uid=$(id -u $USER),gid=$(id -g $USER),metadata
#----------------------------------------------------------------------------------------------------------------

log "brew"

NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && clear
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
#----------------------------------------------------------------------------------------------------------------

log "tools"

brewInstall "eza"
brewInstall "starship"
brewInstall "neovim"
#----------------------------------------------------------------------------------------------------------------

log "code-server"

brewInstall "code-server"

# others
code "jolaleye.horizon-theme-vscode"
code "PKief.material-icon-theme"
code "cmoog.sqlnotebook"
code "pomdtr.excalidraw-editor"
#----------------------------------------------------------------------------------------------------------------

log "kubernetes"

brewInstall "kubernetes-cli"
brewInstall "k9s"
brewInstall "kubeseal"

mkdir -p ~/.kube && cp /mnt/d/secrets/config ~/.kube/config
#----------------------------------------------------------------------------------------------------------------

log "nodejs"

brewInstall "node"
brewInstall "pnpm"
#----------------------------------------------------------------------------------------------------------------

log "docker"

sudo sh -c 'echo "[boot]\nsystemd=true" > /etc/wsl.conf'

curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
#----------------------------------------------------------------------------------------------------------------

log "ssh"

mkdir -p ~/.ssh && cp /mnt/d/secrets/.ssh/id_rsa ~/.ssh/id_rsa && chmod 0400 ~/.ssh/id_rsa
#----------------------------------------------------------------------------------------------------------------

log "git"

brewInstall "gh"
brewInstall "gitui"

gh auth login --git-protocol https --hostname github.com --web --scopes read:packages
git config --global user.name $(gh api user | jq -r '.name')
git config --global user.email $(gh api user | jq -r '.email')

git config --global pull.rebase true
git config --global credential.helper cache
git config --global --replace-all core.editor nvim

git clone https://github.com/MP281X/dotfiles.git ~/dotfiles
(cd ~/dotfiles && bash ./scripts/dotfiles.sh)
#----------------------------------------------------------------------------------------------------------------

log "passwordless sudo"

echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USER

#----------------------------------------------------------------------------------------------------------------

log "reboot"

wsl.exe --shutdown
