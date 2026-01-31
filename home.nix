{ username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.11";

  # Force overwrite existing files
  home.file.".bashrc".force = true;
  home.file.".profile".force = true;

  imports = [
    ./nix
  ];

  # Allow unfree packages (for things like vscode, etc if needed)
  nixpkgs.config.allowUnfree = true;

  # Enable XDG base directories
  xdg.enable = true;

  # Enable Home Manager to manage itself
  programs.home-manager.enable = true;

  # Enable generic Linux support for better WSL integration
  # This provides better integration with non-NixOS systems
  targets.genericLinux.enable = true;

  # Global session variables available to all applications
  home.sessionVariables = {
    EDITOR = "nvim";
    COLORTERM = "truecolor";
    NODE_NO_WARNINGS = "1";
    NIX_CONFIG = "extra-experimental-features = nix-command flakes";
  };
}
