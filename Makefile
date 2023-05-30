dotfiles:
	@echo "neovim"
	@mkdir -p ~/.config/nvim/
	@rm -f ~/.config/nvim/init.lua
	@rm -r -f ~/.config/nvim/lua/*
	@cp neovim-config.lua ~/.config/nvim/init.lua
	@cp -r neovim-config/. ~/.config/nvim/lua/

	@echo "starship"
	@cp starship.toml ~/.config/starship.toml

	@echo "zsh"
	@cp zshrc ~/.zshrc

	@echo "k9s"
	@cp k9s.yaml ~/.config/k9s/skin.yml


neovim-reset:
	@echo "neovim reset"
	@rm -r -f ~/.local/share/nvim/*
