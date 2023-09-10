[ -d ~/blixter ] && rm -rf /mnt/d/secrets/blixter/.env && cp -r ~/blixter/.env /mnt/d/secrets/blixter/.env
[ -d ~/portfolio ] && rm -rf /mnt/d/secrets/portfolio/.env && cp ~/portfolio/.env /mnt/d/secrets/portfolio/.env
[ -d ~/argocd ] && rm -rf /mnt/d/secrets/argocd/secrets && cp -r ~/argocd/secrets /mnt/d/secrets/argocd/secrets 
