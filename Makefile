dotfiles:
	@echo "neovim"
	@mkdir -p ~/.config/nvim/
	@rm -f ~/.config/nvim/init.lua
	@rm -r -f ~/.config/nvim/lua/*
	@cp neovim-config/neovim-config.lua ~/.config/nvim/init.lua
	@cp -r neovim-config/. ~/.config/nvim/lua/

	@echo "starship"
	@cp themes/starship.toml ~/.config/starship.toml

	@echo "zsh"
	@cp zshrc ~/.zshrc

	@echo "k9s"
	@mkdir -p ~/.config/k9s
	@cp themes/k9s.yaml ~/.config/k9s/skin.yml

	@echo "gitui"
	@mkdir -p ~/.config/gitui	
	@cp themes/gitui.ron ~/.config/gitui/theme.ron

neovim-reset:
	@echo "neovim reset"
	@rm -r -f ~/.local/share/nvim/*
