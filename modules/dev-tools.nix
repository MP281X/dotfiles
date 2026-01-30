{ ... }:

{
  home.sessionPath = [
    "$HOME/.bun/bin"
  ];

  # direnv for per-project environment management
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # Bun configuration
  home.file.".bunconfig.json".text = ''
    {
      "install": {
        "cache": true
      }
    }
  '';
}
