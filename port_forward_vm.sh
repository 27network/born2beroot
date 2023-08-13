#!/bin/sh

VM_NAME=$1
if [ -z "$VM_NAME" ]; then
	echo "Usage: $0 <vm_name>"
	exit 1
fi

function fw() {
	VBoxManage modifyvm "$VM_NAME" --natpf1 "$1,tcp,,$2,,$3"
}

fw "ssh" 4242 4242
fw "http" 8080 80
fw "https" 8443 443
fw "ftp" 2121 21
fw "ftp2" 20 20

pasv_min_port=41000
pasv_max_port=42000
for i in $(seq $pasv_min_port $pasv_max_port); do
	fw "ftp_pasv$i" $i $i
done

echo "Done!"
