# load profile
emulate sh -c 'source ~/.profile'
path+=('/usr/local/go/bin')
path+=('/home/mp281x/.go/bin')

# load themes
eval "$(starship init zsh)"
export COLORTERM=truecolor

# case insensitive autocomplete
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# alias
alias vi="nvim"
alias ls="exa --icons"
alias la="exa --icons -a"
alias k9s="k9s --headless -c ns"
alias ssh-dev="ssh mp281x@dev.mp281x.xyz"

# golang
export GOPATH="$HOME/.go"
gonew() {
  mkdir $1 && cd $1 && go mod init github.com/mp281x/$1 && touch main.go
}
pb() {
  f_name=$(echo "$1" | cut -d'.' -f1) && echo $f_name \
  rm -rf $f_name && mkdir -p $f_name && \
  protoc --go_out=$f_name --go_opt=paths=source_relative --go-grpc_out=$f_name --go-grpc_opt=paths=source_relative $f_name.proto
}

# git alias
alias g="gitui"
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


# load pnpm
export PNPM_HOME="/home/$USER/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
