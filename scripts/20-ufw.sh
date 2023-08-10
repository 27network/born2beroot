#!/bin/sh

# Install ufw
apt install -y ufw

# Enable service
systemctl enable --now ufw

# Enable ufw
ufw enable

# Configure & reload
ufw allow 4242
systemctl restart ufw
