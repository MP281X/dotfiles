{ ... }:

{
  # Fuzzy finder
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    defaultOptions = [
      "--no-hscroll"
      "--no-mouse"
      "--reverse"
      "--no-info"
      "--border=none"
    ];
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;

    # History configuration
    historySize = 500;
    historyFileSize = 10000;
    historyControl = [ "erasedups" "ignoredups" "ignorespace" ];

    # Shell options
    shellOptions = [ "histappend" ];

    # Shell initialization
    initExtra = ''
      # Enable vi mode
      set -o vi

      # Custom functions
      cd() {
          builtin cd "$@" && eza --icons --group-directories-first --width 120
      }

      ps() {
        docker ps --all --format '{{json .}}' | jq -s 'map({
          name: .Names,
          status: .Status,
          image: .Image,
          ports: (
            .Ports
            | split(", ")
            | map(select(test("->")))
            | map(capture("0.0.0.0:(?<hostPort>[0-9]+)->(?<containerPort>[0-9]+)"))
            | map(.hostPort + ":" + .containerPort)
          )
        })'
      }

      gl() {
        if [ $# -eq 0 ]; then gh repo list --json name,owner | jq -r '[.[] | "\(.owner.login)/\(.name)"]';
        else gh repo list "$1" --json name,owner | jq -r '[.[] | "\(.owner.login)/\(.name)"]'; fi
      }

      gc() {
        if [[ $1 == *"/"* ]]; then git clone --quiet "https://github.com/$1.git";
        else git clone --quiet "https://github.com/$(git config --get user.name)/$1.git"; fi
      }

      gr() {
        git fetch --prune && git branch -r | awk "{print \$1}" | grep -E -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -D
      }

      reset() {
        find . -type d \( -name "node_modules" -o -name "dist" -o -name ".output" -o -name ".turbo" \) -exec rm -rf {} + 2>/dev/null
        find . -type f \( -name "bun.lock" -o -name ".tsbuildinfo" \) -delete 2>/dev/null
        echo "Cleaned build artifacts"
      }

      # Disable for non-interactive scripts
      [[ $- == *i* ]] || return

      # Tab completion settings
      bind 'TAB:menu-complete'
      bind "set completion-ignore-case on"

      # Cursor shape based on vi mode
      if [[ -n "$PROMPT_COMMAND" ]]; then
        PROMPT_COMMAND="$PROMPT_COMMAND; history -a; echo -ne '\033[5 q'"
      else
        PROMPT_COMMAND="history -a; echo -ne '\033[5 q'"
      fi
      bind 'set vi-cmd-mode-string \1\e[1 q\2'
      bind 'set vi-ins-mode-string \1\e[5 q\2'
      bind 'set keyseq-timeout 10'
      bind 'set show-mode-in-prompt on'

      # GitHub package registry token
      export REGISTRY_TOKEN=$(gh auth token 2>/dev/null || echo "")

      # Show directories in home on shell start
      ls
    '';

    # Aliases
    shellAliases = {
      # File listing
      la = "eza --icons --group-directories-first --width 120 --all";
      ls = "eza --icons --group-directories-first --width 120 --git-ignore --ignore-glob='~/.cache|~/.npm|node_modules'";
      tree = "eza --icons --group-directories-first --width 120 --tree --git-ignore --ignore-glob='~/.cache|~/.npm|node_modules'";

      # Navigation
      ".." = "cd ..";
      rm = "rm -rf";

      # Tools
      vi = "nvim";
      g = "gitui";
      d = "nix develop";

      # Remote
      "ssh-dev" = "ssh $USER@dev.mp281x.xyz";

      # WSL
      reboot = "wsl.exe --shutdown";
      restart = "wsl.exe --shutdown";

      # Opencode
      o = "OPENCODE_EXPERIMENTAL=1 opencode";
    };
  };
}
