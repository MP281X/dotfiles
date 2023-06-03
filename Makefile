dotfiles:
	@echo "neovim"
	@mkdir -p ~/.config/nvim/
	@rm -f ~/.config/nvim/init.lua
	@rm -r -f ~/.config/nvim/lua/*
	@cp neovim/neovim-config.lua ~/.config/nvim/init.lua
	@cp -r neovim/. ~/.config/nvim/lua/

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
	@sudo rm -rf ~/.local/share/nvim
	@sudo rm -rf ~/.local/state/nvim
	@make dotfiles

secrets:
	rm -rf /mnt/d/secrets/portfolio/.env && cp ~/portfolio/.env /mnt/d/secrets/portfolio/.env 
	rm -rf /mnt/d/secrets/argocd/secrets && cp -r ~/argocd/secrets /mnt/d/secrets/argocd/secrets 

load-secrets:
	rm -rf ~/portfolio/.env && cp /mnt/d/secrets/portfolio/.env ~/portfolio/.env
	rm -rf ~/argocd/secrets && cp -r /mnt/d/secrets/argocd/secrets ~/argocd/secrets
