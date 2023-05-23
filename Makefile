dotfiles:
	@echo "neovim"
	@mkdir -p ~/.config/nvim/
	@rm -f ~/.config/nvim/init.lua
	@rm -r -f ~/.config/nvim/lua/*
	@cp neovim-config.lua ~/.config/nvim/init.lua

	@cp -r neovim-config/. ~/.config/nvim/lua/
	@echo "zsh"
	@cp zshrc ~/.zshrc

	@echo "starship"
	@cp starship.toml ~/.config/starship.toml

neovim-reset:
	@echo "neovim reset"
	@rm -r -f ~/.local/share/nvim/*
	@rm -r -f ~/.local/state/*

system-setup:
	@echo "packages"
	@sudo apt update && sudo apt upgrade -y
	@sudo apt install -y gh curl git wget

	@echo "tools"
	@curl -sSf https://atlasgo.sh | sh

	@echo "nodejs"
	@curl -fsSL https://get.pnpm.io/install.sh | sh -
	@source .bashrc
	@pnpm env use --global lts

	@echo "git"
	@gh auth login
	@git config --global user.name = mp281x
	@git config --global user.email = paludgnachmatteo.dev@gmail.com

	@echo "rust setup"
	@sudo apt install gcc g++ musl-dev
	@curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	@source .bashrc

	@echo "zsh /neovim"
	@sudo apt install -y zsh make exa
	@curl -sS https://starship.rs/install.sh | sh
	@chsh
	@cargo install bob-nvim
	@bob use latest
	@make neovim
	
