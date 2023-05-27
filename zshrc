# load starship
eval "$(~/.nix-profile/bin/starship init zsh)"

# case insensitive autocomplete
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
path+=('~/.local/share/pnpm')
path+=('~/.local/share/bob/nvim-bin')
path+=('~/.nix-profile/bin/')

# alias
alias vi="nvim"
alias ls="exa --icons"
alias la="exa --icons -a"

# git alias
alias gs="git status -s --column"
alias ga="git add . && gs"

# list file when i change directory
cd() {
  builtin cd "$@" && exa --icons;
}
