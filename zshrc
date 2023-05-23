# load starship
eval "$(starship init zsh)"

# case insensitive autocomplete
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

path+=('/home/mp281x/.local/share/bob/nvim-bin')

# alias
alias vi="nvim"
alias ls="exa --icons"
alias la="exa --icons -a"

# list file when i change directory
cd() {
  builtin cd "$@" && exa --icons;
}
