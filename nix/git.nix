{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gitui        # Terminal UI for git
  ];

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
      credential.helper = "store";
      core.editor = "nvim";
      user.name = "MP281X";
      user.email = "paludgnachmatteo.dev@gmail.com";
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
      prompt = "enabled";
    };
  };

  # GitUI theme (embedded for simplicity)
  xdg.configFile."gitui/theme.ron".text = ''
    (
        selected_tab: Some("Reset"),
        command_fg: Some("#cdd6f4"),
        selection_bg: Some("#585b70"),
        selection_fg: Some("#cdd6f4"),
        cmdbar_bg: Some("#181825"),
        cmdbar_extra_lines_bg: Some("#181825"),
        disabled_fg: Some("#7f849c"),
        diff_line_add: Some("#a6e3a1"),
        diff_line_delete: Some("#f38ba8"),
        diff_file_added: Some("#a6e3a1"),
        diff_file_removed: Some("#eba0ac"),
        diff_file_moved: Some("#cba6f7"),
        diff_file_modified: Some("#fab387"),
        commit_hash: Some("#b4befe"),
        commit_time: Some("#bac2de"),
        commit_author: Some("#74c7ec"),
        danger_fg: Some("#f38ba8"),
        push_gauge_bg: Some("#89b4fa"),
        push_gauge_fg: Some("#1e1e2e"),
        tag_fg: Some("#f5e0dc"),
        branch_fg: Some("#94e2d5")
    )
  '';
}
