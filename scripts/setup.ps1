Set-ExecutionPolicy RemoteSigned;
wsl --unregister Debian;
wsl --install --no-launch -d Debian;
wsl -d Debian -u root -- useradd -m -s /bin/bash "$Env:UserName";
wsl -d Debian -u root -- bash -c "passwd -d $Env:UserName && usermod -aG sudo $Env:UserName";
wsl -d Debian -u root -- bash -c "echo -e '[user]\ndefault=$Env:UserName' > /etc/wsl.conf";
wsl -d Debian -u root -- bash -c "apt-get update > /dev/null && apt-get install -y curl > /dev/null";
wsl -d Debian -u "$Env:UserName" -- bash -c "bash <(curl -s -L https://raw.githubusercontent.com/MP281X/dotfiles/main/scripts/setup.sh)";
