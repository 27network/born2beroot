#!/bin/sh

# Install vsftpd
apt install -y vsftpd

# Enable service
systemctl enable --now vsftpd

# Add user to userlist
echo $1 | sudo tee -a /etc/vsftpd.userlist

# Edit configuration
## Disable anonymous users
sed -i 's/.*anonymous_enable=.*/anonymous_enable=NO/g' /etc/vsftpd.conf

## Enable local users
sed -i 's/.*local_enable=.*/local_enable=YES/g' /etc/vsftpd.conf
sed -i 's/^write_enable=.*/write_enable=YES/g' /etc/vsftpd.conf
sed -i 's/.*local_umask=.*/local_umask=022/g' /etc/vsftpd.conf

## Enable SSL 
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem <<EOF
US
New York
New York
Example, Inc.
Example
Example

EOF

sed -i 's/.*rsa_cert_file=.*/rsa_cert_file=\/etc\/ssl\/private\/vsftpd.pem/g' /etc/vsftpd.conf
sed -i 's/.*rsa_private_key_file=.*/rsa_private_key_file=\/etc\/ssl\/private\/vsftpd.pem/g' /etc/vsftpd.conf
sed -i 's/.*ssl_enable=.*/ssl_enable=YES/g' /etc/vsftpd.conf

## Enable passive mode
echo "pasv_enable=YES" >> /etc/vsftpd.conf
pasv_min_port=42000
pasv_max_port=42042
echo "pasv_min_port=$pasv_min_port" >> /etc/vsftpd.conf
echo "pasv_max_port=$pasv_max_port" >> /etc/vsftpd.conf
echo "pasv_address=127.0.0.1" >> /etc/vsftpd.conf
echo "pasv_addr_resolve=NO" >> /etc/vsftpd.conf
echo "port_enable=YES" >> /etc/vsftpd.conf

# Reload
systemctl restart vsftpd

# Allow ports
ufw allow 20/tcp
ufw allow 21/tcp
ufw allow $passv_min_port:$passv_max_port/tcp
systemctl restart ufw
