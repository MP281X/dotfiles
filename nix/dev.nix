{ pkgs, lib, ... }:

{
  # Vite+ global bin path
  home.sessionPath = [
    "$HOME/.vite-plus/bin"
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
    bubblewrap           # Sandbox utility used by Codex
    nixd                 # Nix language server
    lua-language-server  # Lua language server
  ];

  xdg.configFile."opencode/opencode.json".source = ../.opencode/opencode.json;

  home.activation.installVitePlus = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -x "$HOME/.vite-plus/bin/vp" ]; then
      echo "Installing Vite+"
      if [ -z "$DRY_RUN_CMD" ]; then
        export VP_NODE_MANAGER="yes"
        ${pkgs.curl}/bin/curl -fsSL https://vite.plus | ${pkgs.bash}/bin/bash
      fi
    fi
  '';

  # Vite+ globals (kept out of Nix to get the latest version)
  home.activation.vitePlusGlobals = lib.hm.dag.entryAfter ["installVitePlus"] ''
    echo "Installing/updating Vite+ global tools"

    export PATH="$HOME/.vite-plus/bin:$PATH"

    vp_global() {
      local pkg="$1"
      echo " - ''${pkg}"
      $DRY_RUN_CMD "$HOME/.vite-plus/bin/vp" add -g "''${pkg}" || true
    }

    vp_global "@kitlangton/motel"
    vp_global "opencode-ai@latest"
    vp_global "@openai/codex@latest"
    vp_global "oxlint@latest"
    vp_global "oxfmt@latest"
    vp_global "@typescript/native-preview@latest"
    vp_global "@tailwindcss/language-server@latest"
  '';
}
