{ pkgs, ... }:

{
  # Install opencode CLI from nixpkgs
  home.packages = [
    pkgs.opencode
  ];

  # Opencode configuration
  xdg.configFile."opencode/opencode.json".source = ../.opencode/opencode.json;

  # Opencode commands
  xdg.configFile."opencode/command" = {
    source = ../.opencode/command;
    recursive = true;
  };

  # BTCA configuration
  xdg.configFile."btca/btca.config.jsonc".source = ../.opencode/btca.json;
}
