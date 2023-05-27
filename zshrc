# load starship
emulate sh -c 'source ~/.profile'
emulate sh -c 'source ~/.bashrc'
eval "$(starship init zsh)"

# case insensitive autocomplete
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

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

