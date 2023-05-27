# load profile
emulate sh -c 'source ~/.profile'

# load pnpm
export PNPM_HOME="/home/$USER/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# load starship
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
alias gl="gh repo list"
gc() {
  git commit -m "$@" && git push
}
gclone() {
  gh repo clone $USER/$@
}

# list file when i change directory
cd() {
  builtin cd "$@" && exa --icons;
}

