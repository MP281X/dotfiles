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
