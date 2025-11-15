#!/bin/bash

clear

log() {
	echo -e ""
	echo -e "\033[1;33m$1\033[0m"
	echo -e ""
}

#----------------------------------------------------------------------------------------------------------------

log "packages"

apt-get update && apt-get upgrade -y
apt-get install -y ufw sudo curl wget htop
apt-get autoremove -y

#----------------------------------------------------------------------------------------------------------------

log "user"

useradd -m -s /bin/bash mp281x
passwd -d mp281x
usermod -aG sudo mp281x
hostnamectl set-hostname dev.mp281x.xyz

#----------------------------------------------------------------------------------------------------------------

log "ssh key"

mkdir -p /home/mp281x/.ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOxArbBf6JivomRmW6pB5OtmGPp1jHJAiAIDMZ/Kh0Hb paludgnachmatteo.dev@gmail.com" >> /home/mp281x/.ssh/authorized_keys
chmod 700 /home/mp281x/.ssh && chmod 600 /home/mp281x/.ssh/authorized_keys
chown -R mp281x:mp281x /home/mp281x/.ssh

#----------------------------------------------------------------------------------------------------------------

log "dokploy"

curl -sSL https://dokploy.com/install.sh | sh

#----------------------------------------------------------------------------------------------------------------

log "ssh"

cat > /etc/ssh/sshd_config << EOF
# Authentication
AllowUsers mp281x
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no

# Rate limiting & DoS protection
MaxSessions 3
MaxAuthTries 3
LoginGraceTime 30

# Security options
PrintMotd no
Compression no
PrintLastLog no
X11Forwarding no
ClientAliveCountMax 3
AllowTcpForwarding yes
ClientAliveInterval 300
EOF

sudo chmod -x /etc/update-motd.d/*
echo "" > /etc/motd

systemctl restart sshd

#----------------------------------------------------------------------------------------------------------------

log "firewall"

sed -i 's/IPV6=yes/IPV6=no/g' /etc/default/ufw
ufw default allow outgoing
ufw default deny incoming
ufw allow 6443
ufw allow 22
ufw enable
