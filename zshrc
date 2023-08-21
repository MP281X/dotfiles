# load profile
emulate sh -c 'source ~/.profile'

# load themes
eval "$(starship init zsh)"
export COLORTERM=truecolor

# plugins
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-syntax-highlighting"
plug "jeffreytse/zsh-vi-mode"

# case insensitive autocomplete
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# load pnpm
export PNPM_HOME="/home/$USER/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac


# alias
alias vi="nvim"
alias ls="exa --icons --git-ignore"
alias la="exa --icons -a"
alias k="k9s --headless -c ns"
alias ssh-dev="ssh mp281x@dev.mp281x.xyz"
alias restart="powershell.exe 'wsl --shutdown'"
img() { explorer.exe "$@"}
cd() { builtin cd "$@" && exa --git-ignore --icons }

# git alias
alias g="gitui"
alias gb="git rev-parse --abbrev-ref HEAD"
alias gl="gh repo list"
gc() { gh repo clone $USER/$@ }

# show file in current directory on start
rm -f ~/.local/state/nvim/shada/main.shada
ls
