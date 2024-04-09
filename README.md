## Setup wsl (run as admin)

```bash
Set-ExecutionPolicy RemoteSigned;
wsl --unregister Debian;
wsl --install --no-launch -d Debian;
debian install --root;
debian run "useradd -m -s /bin/bash mp281x";
debian run "passwd -d mp281x && usermod -aG sudo mp281x";
debian config --default-user mp281x;
debian run "sudo apt-get install curl -y > /dev/null";
debian run "bash <(curl -s -L https://raw.githubusercontent.com/MP281X/dotfiles/main/setup.sh)";
```

