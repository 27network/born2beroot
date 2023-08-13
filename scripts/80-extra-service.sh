#!/bin/sh

# Install vsftpd
apt install -y vsftpd

# Enable service
systemctl enable --now vsftpd

# Add user to userlist
echo $1 | sudo tee -a /etc/vsftpd.userlist

# Edit configuration
sed -i 's/^#write_enable=YES/write_enable=YES/g' /etc/vsftpd.conf
sed -i 's/^#local_umask=022/local_umask=022/g' /etc/vsftpd.conf
echo "userlist_enable=YES" >> /etc/vsftpd.conf
echo "userlist_file=/etc/vsftpd.userlist" >> /etc/vsftpd.conf
echo "userlist_deny=NO" >> /etc/vsftpd.conf
