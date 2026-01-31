{ ... }:

{
  programs.git = {
    enable = true;

    # Use settings attribute set for type-safe configuration
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
      credential.helper = "store";
      core.editor = "nvim";

      # User configuration
      user.name = "MP281X";
      user.email = "paludgnachmatteo.dev@gmail.com";
    };
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
      prompt = "enabled";
    };
  };

  # GitUI theme configuration
  xdg.configFile."gitui/theme.ron".source = ../config/gitui.ron;
}
