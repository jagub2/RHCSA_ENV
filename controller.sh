#!/bin/bash
sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*

echo "[TASK 1] Install required packages"
yum install -y samba-client cifs-utils httpd vim epel-release vdo kmod-kvdo
#yum install -y sshpass
yum install -y http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/sshpass-1.09-4.el8.x86_64.rpm

echo "[TASK 2] Modify /etc/hosts"
echo "192.168.50.211 nfs.com" >> /etc/hosts
echo "192.168.50.212 cifs.com" >> /etc/hosts

echo "[TASK 3] Configure ssh keys"
su - vagrant << "EOF"
mkdir -v /home/vagrant/.ssh 
cd /home/vagrant/.ssh 
ssh-keygen -N "" -f id_rsa # Generate public and private key pairs (id_rsa, id_rsa.pub)
# Copy SSH Keys
sshpass -p "vagrant" ssh-copy-id -o StrictHostKeyChecking=no -i id_rsa.pub vagrant@nfs.com 
sshpass -p "vagrant" ssh-copy-id -o StrictHostKeyChecking=no -i id_rsa.pub vagrant@cifs.com 
EOF
