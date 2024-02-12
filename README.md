## Setup wsl

```bash
wsl --install -d Debian
```

## Reset wsl (run as admin)

```bash
winget uninstall --id Debian.Debian \
wsl --unregister Debian \
wsl --install -d Debian
```

## Debian setup

```bash
vi init.sh && \
bash init.sh && \
rm init.sh
```

### Init script

```bash
echo "packages"
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y curl git wget xz-utils unzip
sudo apt-get install -y gcc g++ # neovim

echo "homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/mp281x/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo "shell tools"
brew install bob
brew install ripgrep
brew install jq
brew install exa
brew install zsh
brew install starship
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
sudo chsh -s "$(command -v zsh)" "${USER}"

echo "tools"
curl -sSf https://atlasgo.sh | sh

echo "git"
brew install gh
brew install gitui

echo "kubernetes"
brew install kubernetes-cli
brew install k9s
brew install kubeseal
mkdir -p ~/.kube && cp /mnt/d/secrets/config ~/.kube/config

echo "neovim"
bob use nightly

echo "ssh"
mkdir -p ~/.ssh && cp /mnt/d/secrets/.ssh/id_rsa ~/.ssh/id_rsa && chmod 0400 ~/.ssh/id_rsa

echo "git"
git config --global user.name = mp281x
git config --global user.email = paludgnachmatteo.dev@gmail.com
git config --global --replace-all core.editor nvim
git config --global pull.rebase true
gh auth login
git clone https://github.com/MP281X/dotfiles ~/dotfiles
(cd ~/dotfiles && bash ./scripts/dotfiles.sh)

echo "nodejs"
curl -fsSL https://get.pnpm.io/install.sh | sh -
export PNPM_HOME="/home/mp281x/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
pnpm env use --global lts

echo "bun"
curl -fsSL https://bun.sh/install | bash

```
