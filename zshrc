# load profile
emulate sh -c 'source ~/.profile'
path+=('/usr/local/go/bin')
path+=('/home/mp281x/.go/bin')

# alias
alias vi="nvim"
alias c="clear"
alias ls="exa --icons --git-ignore"
alias la="exa --icons -a"
alias k9s="k9s --headless -c ns"
alias ssh-dev="ssh mp281x@dev.mp281x.xyz"
img() { explorer.exe "$@"}
cd() { builtin cd "$@" && exa --git-ignore --icons }
t() { exa --tree --git-ignore "$@" }

# git alias
alias g="gitui"
alias gl="gh repo list"
gc() { gh repo clone $USER/$@ }

# golang
export GOPATH="$HOME/.go"
goinit() { mkdir $1 && cd $1 && go mod init github.com/mp281x/$1 && touch main.go }
pb() {
  f_name=$(echo "$1" | cut -d'.' -f1) && echo $f_name \
  rm -rf $f_name && mkdir -p $f_name && \
  protoc --go_out=$f_name --go_opt=paths=source_relative --go-grpc_out=$f_name --go-grpc_opt=paths=source_relative $f_name.proto
}

# load themes
eval "$(starship init zsh)"
export COLORTERM=truecolor

# show file in current directory on start
ls

# case insensitive autocomplete
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# plugins
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-syntax-highlighting"

# load pnpm
export PNPM_HOME="/home/$USER/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
