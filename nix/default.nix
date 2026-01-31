{
  imports = [
    ./core.nix      # Core system packages
    ./shell.nix     # Bash shell configuration and terminal tools
    ./git.nix       # Git and GitHub CLI
    ./prompt.nix    # Starship prompt
    ./dev.nix       # Development environment (Neovim, Opencode, LSPs, bun)
    ./wsl.nix       # WSL-specific configurations
  ];
}
