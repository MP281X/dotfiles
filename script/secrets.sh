[ -d ~/portfolio/ ] && rm -rf /mnt/d/secrets/portfolio/.env && cp ~/portfolio/.env /mnt/d/secrets/portfolio/.env 
[ -d ~/devDash/ ] && rm -rf /mnt/d/secrets/devDash/.env && cp ~/devDash/.env /mnt/d/secrets/devDash/.env
[ -d ~/argocd ] && rm -rf /mnt/d/secrets/argocd/secrets && cp -r ~/argocd/secrets /mnt/d/secrets/argocd/secrets 
