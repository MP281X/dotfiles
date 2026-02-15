{ pkgs, lib, ... }:

{
  # Bun global bin path
  home.sessionPath = [
    "$HOME/.cache/.bun/bin"
    "$HOME/.bun/bin"
  ];

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Link Neovim configuration
  xdg.configFile."nvim" = {
    source = ../nvim;
    recursive = true;
  };

  # Bun, Node and Nix-only LSP servers
  home.packages = with pkgs; [
    bun                           # Bun runtime
    nodejs_22                   # Node.js v22 for LSP and convex
    lua-language-server          # Lua (not available via Bun)
    nixd                          # Nix (not available via Bun)
  ];

  xdg.configFile."opencode/opencode.json".source = ../.opencode/opencode.json;

  xdg.configFile."opencode/command" = {
    source = ../.opencode/command;
    recursive = true;
  };

  xdg.configFile."btca/btca.config.jsonc".source = ../.opencode/btca.json;

  # Bun globals (kept out of Nix to get the latest version)
  home.activation.bunGlobals = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Installing/updating Bun global tools"

    install_bun_global() {
      local pkg="$1"
      echo " - ''${pkg}"
      $DRY_RUN_CMD ${pkgs.bun}/bin/bun add -g "''${pkg}" || true
    }

    install_bun_global "btca@latest"
    install_bun_global "opencode-ai@latest"
    install_bun_global "@biomejs/biome@latest"
    install_bun_global "@typescript/native-preview@latest"
    install_bun_global "@tailwindcss/language-server@latest"
  '';
}
