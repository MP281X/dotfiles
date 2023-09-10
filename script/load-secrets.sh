[ -d ~/blixter ] && rm -rf ~/blixter/.env && cp -r /mnt/d/secrets/blixter/.env ~/blixter/.env
[ -d ~/argocd ] && rm -rf ~/argocd/secrets && cp -r /mnt/d/secrets/argocd/secrets ~/argocd/secrets
[ -d ~/portfolio/ ] && rm -rf ~/portfolio/.env && cp /mnt/d/secrets/portfolio/.env ~/portfolio/.env
