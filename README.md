# Dotfiles

Managed with Nix + Home Manager

## Setup WSL (run as admin in PowerShell)

```powershell
wsl --unregister Debian;
wsl --install -d Debian;
```

## Manual Setup (after WSL install)

### 1. Configure User Permissions

```bash
sudo passwd -d $USER && sudo usermod -aG sudo $USER
sudo apt-get update && sudo apt-get upgrade -y
```

### 2. Install Nix Package Manager

```bash
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

### 3. Clone Dotfiles

```bash
git clone https://github.com/MP281X/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 4. Apply Configuration

```bash
NIX_CONFIG='extra-experimental-features = nix-command flakes' nix run home-manager/master -- switch --flake .#mp281x
```

### 5. Setup GitHub Authentication

```bash
gh auth login --git-protocol https --hostname github.com --web --scopes read:packages
```
