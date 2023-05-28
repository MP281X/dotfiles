dotfiles:
	@echo "neovim"
	@mkdir -p ~/.config/nvim/
	@rm -f ~/.config/nvim/init.lua
	@rm -r -f ~/.config/nvim/lua/*
	@cp neovim-config.lua ~/.config/nvim/init.lua
	@cp -r neovim-config/. ~/.config/nvim/lua/

	@echo "starship"
	@cp shell/starship.toml ~/.config/starship.toml

	@echo "zsh"
	@cp zshrc ~/.zshrc

neovim-reset:
	@echo "neovim reset"
	@rm -r -f ~/.local/share/nvim/*
