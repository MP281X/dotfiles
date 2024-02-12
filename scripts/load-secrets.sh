[ -d ~/blixter ] && rm -rf ~/blixter/.env && cp -r /mnt/f/secrets/blixter/.env ~/blixter/.env
[ -d ~/argocd ] && rm -rf ~/argocd/secrets && cp -r /mnt/f/secrets/argocd/secrets ~/argocd/secrets
[ -d ~/portfolio/ ] && rm -rf ~/portfolio/.env && cp /mnt/f/secrets/portfolio/.env ~/portfolio/.env
