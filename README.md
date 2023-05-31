## Setup wsl

```bash
wsl --set-default-version 2 \
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
sudo apt-get install -y curl git wget xz-utils make
sudo apt-get install -y gcc g++ musl-dev build-essential

echo "homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/mp281x/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo "shell tools"
brew install neovim
brew install exa
brew install zsh
brew install starship

sudo chsh -s "$(command -v zsh)" "${USER}"

echo "tools"
brew install atlas
brew install protobuf

echo "git"
brew install gh
brew install gitui

echo "kubernetes"
brew install kubernetes-cli
brew install k9s
brew install kubeseal
mkdir -p ~/.kube && cp /mnt/d/secrets/config ~/.kube/config

echo "ssh"
mkdir -p ~/.ssh && cp /mnt/d/secrets/.ssh/id_rsa ~/.ssh/id_rsa && chmod 0400 ~/.ssh/id_rsa

echo "git"
git config --global user.name = $USER
git config --global user.email = paludgnachmatteo.dev@gmail.com
git config --global pull.rebase true
gh auth login
git clone https://github.com/MP281X/dotfiles ~/dotfiles
(cd ~/dotfiles && make dotfiles)

echo "nodejs"
curl -fsSL https://get.pnpm.io/install.sh | sh -
export PNPM_HOME="/home/mp281x/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
pnpm env use --global lts

echo "golang"
export go_version="1.20.4"
wget https://go.dev/dl/go$go_version.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go$go_version.linux-amd64.tar.gz && sudo rm -f go$go_version.linux-amd64.tar.gz

echo "rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.profile && source ~/.bashrc
```
