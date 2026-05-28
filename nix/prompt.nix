{ ... }:

{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      add_newline = false;
      format = "$rust$golang$directory$git_branch[❯ ](bold red)";

      git_branch = {
        format = "[⚡$branch ](bold red)";
      };

      directory = {
        style = "bold blue";
      };

      golang = {
        format = "[\\[󰟓 $version\\]](bold black) ";
      };

      rust = {
        format = "[\\[ $version\\]](bold black) ";
      };
    };
  };
}
