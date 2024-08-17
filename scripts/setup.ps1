Set-ExecutionPolicy RemoteSigned;
wsl --unregister Debian;
wsl --install --no-launch -d Debian;
debian install --root;
debian run "useradd -m -s /bin/bash $Env:UserName";
debian run "passwd -d $Env:UserName && usermod -aG sudo $Env:UserName";
debian config --default-user $Env:UserName;
debian run "sudo apt-get update > /dev/null && sudo apt-get install curl -y > /dev/null";
debian run "bash <(curl -s -L https://raw.githubusercontent.com/MP281X/dotfiles/main/scripts/setup.sh)";
