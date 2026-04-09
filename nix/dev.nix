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
    withRuby = false;
    withPython3 = false;
  };

  # Link Neovim configuration
  xdg.configFile."nvim" = {
    source = ../nvim;
    recursive = true;
  };

  home.packages = with pkgs; [
    bun                  # Bun runtime
    nodejs_25            # Node.js v25 for LSP
    nixd                 # Nix (not available via Bun)
    lua-language-server  # Lua (not available via Bun)
  ];

  xdg.configFile."opencode/opencode.json".source = ../.opencode/opencode.json;
  xdg.configFile."opencode/command" = {
    source = ../.opencode/command;
    recursive = true;
  };

  # Bun globals (kept out of Nix to get the latest version)
  home.activation.bunGlobals = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Installing/updating Bun global tools"

    export BUN_INSTALL="$HOME/.cache/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"

    install_bun_global() {
      local pkg="$1"
      echo " - ''${pkg}"
      $DRY_RUN_CMD ${pkgs.bun}/bin/bun add -g "''${pkg}" || true
    }

    install_bun_global "opencode-ai@latest"
    install_bun_global "@biomejs/biome@latest"
    install_bun_global "@typescript/native-preview@latest"
    install_bun_global "@tailwindcss/language-server@latest"
  '';
}
