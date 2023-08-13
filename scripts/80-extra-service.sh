#!/bin/sh

# Install vsftpd
apt install -y vsftpd

# Enable service
systemctl enable --now vsftpd

# Add user to userlist
echo $1 | sudo tee -a /etc/vsftpd.userlist

# Edit configuration
sed -i 's/^listen=NO/listen=YES/g' /etc/vsftpd.conf
sed -i 's/^listen_ipv6=YES/listen_ipv6=NO/g' /etc/vsftpd.conf
sed -i 's/^anonymous_enable=YES/anonymous_enable=NO/g' /etc/vsftpd.conf
sed -i 's/^#local_enable=YES/local_enable=YES/g' /etc/vsftpd.conf
sed -i 's/^#write_enable=YES/write_enable=YES/g' /etc/vsftpd.conf
sed -i 's/^#local_umask=022/local_umask=022/g' /etc/vsftpd.conf
sed -i 's/^#chroot_local_user=YES/chroot_local_user=YES/g' /etc/vsftpd.conf
echo "allow_writeable_chroot=YES" >> /etc/vsftpd.conf
echo "userlist_enable=YES" >> /etc/vsftpd.conf
echo "userlist_file=/etc/vsftpd.userlist" >> /etc/vsftpd.conf
echo "userlist_deny=NO" >> /etc/vsftpd.conf
pasv_min_port=1337
pasv_max_port=1339
echo "pasv_min_port=$pasv_min_port" >> /etc/vsftpd.conf
echo "pasv_max_port=$pasv_max_port" >> /etc/vsftpd.conf

# Reload
systemctl restart vsftpd

# Allow ports
ufw allow 21/tcp
for i in $(seq $pasv_min_port $pasv_max_port); do
	ufw allow $i/tcp
done
systemctl restart ufw
