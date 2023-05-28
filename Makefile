dotfiles:
	@echo "neovim"
	@mkdir -p ~/.config/nvim/
	@rm -f ~/.config/nvim/init.lua
	@rm -r -f ~/.config/nvim/lua/*
	@cp neovim-config.lua ~/.config/nvim/init.lua
	@cp -r neovim-config/. ~/.config/nvim/lua/

	@echo "starship"
	@cp starship.toml ~/.config/starship.toml

	@echo "nushell"
	@cp shell/config.nu ~/.config/nushell/config.nu
	@cp shell/env.nu ~/.config/nushell/env.nu

neovim-reset:
	@echo "neovim reset"
	@rm -r -f ~/.local/share/nvim/*
