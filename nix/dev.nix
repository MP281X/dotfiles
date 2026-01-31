{ pkgs, lib, ... }:

{
  # Bun path
  home.sessionPath = [ "$HOME/.bun/bin" ];

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
    opencode                     # Opencode CLI
    bun                           # Bun runtime
    nodejs                      # Node.js for LSP
    lua-language-server          # Lua (not available via Bun)
    nixd                          # Nix (not available via Bun)
  ];

  xdg.configFile."opencode/opencode.json".source = ../.opencode/opencode.json;

  xdg.configFile."opencode/command" = {
    source = ../.opencode/command;
    recursive = true;
  };

  # LSP servers installed via Bun for consistency
  # Matches nvim/lua/plugins/lsp.lua: tsgo, biome, tailwindcss, lua_ls, nixd
  home.activation.lspServers = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Installing/updating LSP servers"
    $DRY_RUN_CMD ${pkgs.bun}/bin/bun add -g "@typescript/native-preview@latest" "@biomejs/biome@latest" "@tailwindcss/language-server@latest" || true
  '';
}
