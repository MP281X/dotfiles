# Dotfiles

Managed with Nix + Home Manager

## Setup WSL (run as admin in PowerShell)

```powershell
wsl --unregister Debian;
wsl --install --no-launch -d Debian;
wsl -d Debian -u root -- useradd -m -s /bin/bash "$Env:UserName";
wsl -d Debian -u root -- bash -c "passwd -d $Env:UserName && usermod -aG sudo $Env:UserName";
wsl -d Debian -u root -- bash -c "echo -e '[user]\ndefault=$Env:UserName' > /etc/wsl.conf";
wsl -d Debian -u root -- bash -c "apt-get update > /dev/null && apt-get install -y curl > /dev/null";
```

## Manual Setup (after WSL install)

### 1. Install Nix Package Manager

```bash
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
```

Restart your shell or run:

```bash
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

### 2. Clone Dotfiles

```bash
git clone https://github.com/MP281X/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 3. Apply Configuration

```bash
NIX_CONFIG='extra-experimental-features = nix-command flakes' nix run home-manager/master -- switch --flake .#mp281xbun i
```

### 4. Setup GitHub Authentication

```bash
gh auth login --git-protocol https --hostname github.com --web --scopes read:packages
```

### 5. Setup Docker

```bash
# Enable systemd in WSL
sudo sh -c 'printf "[boot]\nsystemd=true\n" > /etc/wsl.conf'

# Install Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
```

Restart WSL:

```bash
wsl.exe --shutdown
```

## Update Configuration

After making changes to the flake:

```bash
cd ~/.dotfiles
home-manager switch --flake .#mp281x
```

Or use the alias:

```bash
nix-switch
```

## Available Aliases

### Nix

- `nix-switch` - Apply home-manager configuration
- `nix-update` - Update flake inputs and apply
- `nix-clean` - Collect garbage and free space

### Navigation

- `la` - List all files with icons
- `ls` - List files with git ignore
- `tree` - Tree view with git ignore
- `cat` - Use `bat` instead of cat
- `..` - Go up one directory

### Development

- `i` - Smart install (detects bun.lockb)
- `g` - Open gitui
- `vi` - Open neovim
- `o` - Run opencode
- `dps` - Docker ps with formatted JSON output
- `da` - Allow direnv
- `dr` - Reload direnv

### Git

- `gl [user]` - List GitHub repos
- `gc <repo>` - Clone GitHub repo
- `gr` - Prune stale branches

### WSL

- `reboot` / `restart` - Shutdown WSL

## Structure

- `flake.nix` - Entry point defining Home Manager configuration
- `home.nix` - Main Home Manager configuration
- `modules/` - Modular configuration files:
  - `default.nix` - Module entrypoint (aggregates all imports)
  - `packages.nix` - All installed packages
  - `bash.nix` - Shell configuration with aliases and functions
  - `git.nix` - Git and GitHub CLI configuration
  - `starship.nix` - Shell prompt configuration
  - `neovim.nix` - Editor configuration
  - `dev-tools.nix` - Bun and development tools
  - `wsl.nix` - WSL-specific settings and Windows integration
  - `opencode.nix` - Opencode tool configuration
  - `bun-packages.nix` - Automatic installation of Bun global packages (tsgo)
- `config/` - Static configuration files (gitui, windows-terminal)
- `nvim/` - Neovim Lua configuration (kept standalone)
- `windows/` - WSL-Windows integration files (win32yank, AutoHotkey)
- `.opencode/` - Opencode configuration and commands
