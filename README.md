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
brew install gh
brew install atlas

echo "git"
git config --global user.name = $USER
git config --global user.email = paludgnachmatteo.dev@gmail.com
git config --global pull.rebase true
gh auth login
git clone https://github.com/MP281X/dotfiles ~/dotfiles
(cd ~/dotfiles && make dotfiles)

echo "nodejs"
brew install node
brew install pnpm

echo "rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.profile && source ~/.bashrc
```
