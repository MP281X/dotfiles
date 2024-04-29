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
sudo apt-get install -y lshw  > /dev/null # ollama
#----------------------------------------------------------------------------------------------------------------

log "nix"
sh <(curl -s -L https://nixos.org/nix/install) --no-daemon > /dev/null
source "$HOME/.nix-profile/etc/profile.d/nix.sh"
#----------------------------------------------------------------------------------------------------------------

log "shell"
nix-env -iA nixpkgs.eza --quiet
nix-env -iA nixpkgs.starship --quiet
#----------------------------------------------------------------------------------------------------------------

log "bob"
wget --quiet https://github.com/MordechaiHadad/bob/releases/download/v2.8.1/bob-linux-x86_64-openssl.zip
unzip -p bob-linux-x86_64-openssl.zip bob-linux-x86_64-openssl/bob > bob && rm bob-linux-x86_64-openssl.zip
sudo mv bob /usr/local/bin/bob && sudo chmod +x /usr/local/bin/bob
#----------------------------------------------------------------------------------------------------------------

log "neovim"
nix-env -iA nixpkgs.ripgrep --quiet
nix-env -iA nixpkgs.jq --quiet
bob use nightly
#----------------------------------------------------------------------------------------------------------------

log "code-server"
curl -fsSL https://code-server.dev/install.sh | sh
sudo systemctl enable --now code-server@$USER 2>/dev/null
sudo systemctl start --now code-server@$USER 2>/dev/null
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
code "cmoog.sqlnotebook"
code "Orta.vscode-twoslash-queries"
code "pomdtr.excalidraw-editor"
#----------------------------------------------------------------------------------------------------------------

log "kubernetes"
nix-env -iA nixpkgs.kubectl --quiet
nix-env -iA nixpkgs.k9s --quiet
nix-env -iA nixpkgs.kubeseal --quiet
mkdir -p ~/.kube && cp /mnt/d/secrets/config ~/.kube/config
#----------------------------------------------------------------------------------------------------------------

log "nodejs"
curl -fsSL https://get.pnpm.io/install.sh | sh -
export PNPM_HOME="/home/$USER/.local/share/pnpm"
case ":$PATH:" in *":$PNPM_HOME:"*) ;; *) export PATH="$PNPM_HOME:$PATH" ;; esac
pnpm env use --global latest
#----------------------------------------------------------------------------------------------------------------

log "bun"
curl -fsSL https://bun.sh/install | bash
#----------------------------------------------------------------------------------------------------------------

log "docker"
sudo sh -c 'echo "[boot]\nsystemd=true" > /etc/wsl.conf'
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
#----------------------------------------------------------------------------------------------------------------

log "ollama"
curl -fsSL https://ollama.com/install.sh | sh
#----------------------------------------------------------------------------------------------------------------

log "ssh"
mkdir -p ~/.ssh && cp /mnt/d/secrets/.ssh/id_rsa ~/.ssh/id_rsa && chmod 0400 ~/.ssh/id_rsa
#----------------------------------------------------------------------------------------------------------------

log "git"
nix-env -iA nixpkgs.gh --quiet
nix-env -iA nixpkgs.gitui --quiet

gh auth login --git-protocol https --hostname github.com --web
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
