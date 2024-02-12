[ -d ~/blixter ] && rm -rf /mnt/d/secrets/blixter/.env && mkdir -p /mnt/d/secrets/blixter && cp ~/blixter/.env /mnt/d/secrets/blixter/.env
[ -d ~/portfolio ] && rm -rf /mnt/d/secrets/portfolio/.env && mkdir -p /mnt/d/secrets/portfolio && cp ~/portfolio/.env /mnt/d/secrets/portfolio/.env
[ -d ~/argocd ] && rm -rf /mnt/d/secrets/argocd/secrets && mkdir -p /mnt/d/secrets/argocd && cp -r ~/argocd/secrets /mnt/d/secrets/argocd/secrets 
