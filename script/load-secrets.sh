[ -d ~/portfolio/ ] && rm -rf ~/portfolio/.env && cp /mnt/d/secrets/portfolio/.env ~/portfolio/.env
[ -d ~/devDash/ ] && rm -rf ~/devDash/.env && cp /mnt/d/secrets/devDash/.env ~/portfolio/.env
[ -d ~/argocd ] && rm -rf ~/argocd/secrets && cp -r /mnt/d/secrets/argocd/secrets ~/argocd/secrets
