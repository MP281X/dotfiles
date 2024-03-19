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

echo "nix"
sh <(curl -L https://nixos.org/nix/install) --no-daemon
. /home/mp281x/.nix-profile/etc/profile.d/nix.sh

echo "bob"
wget --quiet https://github.com/MordechaiHadad/bob/releases/download/v2.8.1/bob-linux-x86_64-openssl.zip
unzip -p bob-linux-x86_64-openssl.zip bob-linux-x86_64-openssl/bob > bob
sudo mv bob /usr/local/bin/bob
sudo chmod +x /usr/local/bin/bob
rm bob-linux-x86_64-openssl.zip

echo "shell tools"
sudo apt install -y exa jq ripgrep
nix-env -iA nixpkgs.zsh --quiet
nix-env -iA nixpkgs.starship --quiet

zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
sudo chsh -s "$(command -v zsh)" "${USER}"

echo "tools"
curl -sSf https://atlasgo.sh | sh

echo "git"
nix-env -iA nixpkgs.gh --quiet
nix-env -iA nixpkgs.gitui --quiet

echo "kubernetes"
nix-env -iA nixpkgs.kubectl --quiet
nix-env -iA nixpkgs.k9s --quiet
nix-env -iA nixpkgs.kubeseal --quiet
mkdir -p ~/.kube && cp /mnt/d/secrets/config ~/.kube/config

echo "neovim"
bob use nightly

echo "ssh"
mkdir -p ~/.ssh && cp /mnt/d/secrets/.ssh/id_rsa ~/.ssh/id_rsa && chmod 0400 ~/.ssh/id_rsa

echo "git"
gh auth login
git config --global user.name = mp281x
git config --global user.email = paludgnachmatteo.dev@gmail.com
git config --global --replace-all core.editor nvim
git config --global pull.rebase true
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
