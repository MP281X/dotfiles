## Setup wsl

```bash
wsl --set-default-version 2 \
wsl --install -d Debian
```

## Reset wsl

```bash
wsl --unregister Debian \
wsl --install -d Debian
```

## Debian setup

```bash
vi init.sh # <- init script
bash init.sh && rm init.sh
```

### Init script

```bash
echo "packages"
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git wget xz-utils make
sudo apt install -y gcc g++ musl-dev

echo "nix"
sudo mkdir -p -m 0755 /nix && sudo chown $USER /nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon
source ~/.profile && source ~/.bashrc
. ~/.nix-profile/etc/profile.d/nix.sh

echo "cli tools"
nix-env -iA nixpkgs.neovim
nix-env -iA nixpkgs.exa
nix-env -iA nixpkgs.zsh
nix-env -iA nixpkgs.starship
nix-env -iA nixpkgs.gh
curl -sSf https://atlasgo.sh | sh

echo "git"
git config --global user.name = $USER
git config --global user.email = paludgnachmatteo.dev@gmail.com
gh auth login
git clone https://github.com/MP281X/dotfiles ~/dotfiles

echo "nodejs"
curl -fsSL https://get.pnpm.io/install.sh | sh -
source .bashrc
pnpm env use --global lts

echo "rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.bashrc

```
