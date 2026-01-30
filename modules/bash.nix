{ ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    # History configuration
    historySize = 500;
    historyFileSize = 10000;
    historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
    historyAppend = true;

    # Shell options
    shellOptions = [
      "vi"
    ];

    # Shell initExtra for interactive shell features
    initExtra = ''
      # Disable for non-interactive scripts
      [[ $- == *i* ]] || return

      # Tab completion settings
      bind 'TAB:menu-complete'
      bind "set completion-ignore-case on"

      # Cursor shape based on vi mode (append to existing PROMPT_COMMAND)
      if [[ -n "$PROMPT_COMMAND" ]]; then
        PROMPT_COMMAND="$PROMPT_COMMAND; history -a; echo -ne '\033[5 q'"
      else
        PROMPT_COMMAND="history -a; echo -ne '\033[5 q'"
      fi
      bind 'set vi-cmd-mode-string \1\e[1 q\2'
      bind 'set vi-ins-mode-string \1\e[5 q\2'
      bind 'set keyseq-timeout 10'
      bind 'set show-mode-in-prompt on'

      # GitHub package registry token (set if gh is authenticated)
      if command -v gh >/dev/null 2>&1; then
        export REGISTRY_TOKEN=$(gh auth token 2>/dev/null || echo "")
      fi
    '';

    # Aliases
    shellAliases = {
      # ls replacements using eza
      la = "eza --icons --group-directories-first --width 120 --all";
      ls = "eza --icons --group-directories-first --width 120 --git-ignore --ignore-glob='~/.cache|~/.npm|node_modules'";
      tree = "eza --icons --group-directories-first --width 120 --tree --git-ignore --ignore-glob='~/.cache|~/.npm|node_modules'";

      # Navigation
      ".." = "cd ..";
      rm = "rm -rf";

      # Tools
      vi = "nvim";
      "ssh-dev" = "ssh $USER@dev.mp281x.xyz";
      cat = "bat";
      g = "gitui";

      # WSL
      reboot = "wsl.exe --shutdown";
      restart = "wsl.exe --shutdown";

      # Package manager
      o = "OPENCODE_EXPERIMENTAL=1 opencode";

      # Nix helpers
      nix-switch = "home-manager switch --flake ~/.dotfiles#mp281x";
      nix-update = "nix flake update ~/.dotfiles && home-manager switch --flake ~/.dotfiles#mp281x";
      nix-clean = "nix-collect-garbage -d";

      # Direnv
      da = "direnv allow";
      dr = "direnv reload";
    };

    # Functions (using initExtra since shellAliases only supports simple aliases)
    initExtraFirst = ''
      # Custom cd with auto-ls
      cd() {
          builtin cd "$@" && eza --icons --group-directories-first --width 120
      }

      # Smart install based on lockfile
      i() {
        if [ -f "bun.lockb" ]; then bun install;
        else echo "No bun.lockb file found"; fi
      }

      # Docker ps with formatted output
      dps() {
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

      # List GitHub repos
      gl() {
        if [ $# -eq 0 ]; then gh repo list --json name,owner | jq -r '[.[] | "\(.owner.login)/\(.name)"]';
        else gh repo list "$1" --json name,owner | jq -r '[.[] | "\(.owner.login)/\(.name)"]'; fi
      }

      # Clone GitHub repo
      gc() {
        if [[ $1 == *"/"* ]]; then git clone --quiet "https://github.com/$1.git";
        else git clone --quiet "https://github.com/$(git config --get user.name)/$1.git"; fi
      }

      # Prune stale branches
      gr() {
        git fetch --prune && git branch -r | awk "{print \$1}" | grep -E -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -D
      }
    '';
  };

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

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };
}
