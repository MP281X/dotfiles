{ ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Link the existing Neovim configuration
  xdg.configFile."nvim" = {
    source = ../nvim;
    recursive = true;
  };
}
