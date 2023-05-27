echo "packages"
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git wget xz-utils make

echo "nix"
sh <(curl -L https://nixos.org/nix/install) --no-daemon
source .bashrc

echo "cli tools"
nix-env -iA nixpkgs.neovim
nix-env -iA nixpkgs.exa
nix-env -iA nixpkgs.zsh
nix-env -iA nixpkgs.starship
nix-env -iA nixpkgs.gh
curl -sSf https://atlasgo.sh | sh

echo "git"
git config --global user.name = mp281x
git config --global user.email = paludgnachmatteo.dev@gmail.com
gh auth login

echo "nodejs"
curl -fsSL https://get.pnpm.io/install.sh | sh -
source .bashrc
pnpm env use --global lts

echo "rust"
sudo apt install gcc g++ musl-dev
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source .bashrc
