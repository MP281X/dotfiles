# load starship
eval "$(starship init zsh)"

# case insensitive autocomplete
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# alias
alias vi="nvim"
alias ls="exa --long --git --icons --no-permissions --no-filesize --no-user --no-time -a"

# list file when i change directory
cd() {
  builtin cd "$@" && exa --icons;
}
