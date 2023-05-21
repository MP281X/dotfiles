dotfiles:
	@echo "neovim"
	@mkdir -p ~/.config/nvim/
	@rm -f ~/.config/nvim/init.lua
	@rm -r -f ~/.config/nvim/lua/*
	@cp neovim-config.lua ~/.config/nvim/init.lua	
	@cp -r neovim-config/. ~/.config/nvim/lua/
	
	@echo "zsh"
	@cp .zshrc ~/.zshrc

	@echo "starship"
	@cp starship.toml ~/.config/starship.toml

neovim-reset:
	@echo "neovim reset"
	@rm -f ~/.local/share/nvim/*

initial-setup:
	@echo "setup apk repo"
	@echo "https://dl-cdn.alpinelinux.org/alpine/latest-stable/main" > /etc/apk/repositories
	@echo "https://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories
	@echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
	@echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
	@echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
	@apk update

	@echo "setup basic tools"
	@apk add neovim zsh make exa github-cli starship
	@make dotfiles
	
	@echo "setup other tools"
	@apk add atlas 

	@echo "nodejs setup"
	@apk add nodejs npm
	@npm i -g pnpm
	
	@echo "rust setup"
	@apk add curl gcc g++ musl-dev
	@curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	@source "$HOME/.cargo/env"

	@echo "tailscale setup"
	@apk add tailscale
	@rc-update add tailscale
	@rc-service tailscale start
	@tailscale up --advertise-tags=tag:dev
	
	@echo "git / github cli setup"
	@gh auth login
