## Setup wsl

wsl --set-default-version 2 \
wsl --install -d Debian

## Reset wsl

wsl --unregister Debian \
wsl --install -d Debian
