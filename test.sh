#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
cat << "EOF"

                           _
 ___  ___  _ __   __ _ ___| |__  _   _  __      _____
/ __|/ _ \| '_ \ / _` / __| '_ \| | | | \ \ /\ / / _ \
\__ \ (_) | | | | (_| \__ \ | | | |_| |  \ V  V / (_) |
|___/\___/|_| |_|\__, |___/_| |_|\__,_|   \_/\_/ \___/
                 |___/


Author: songshu wo
EOF
cd /root/gandi-ddns
cp config-template.txt config.txt
echo -n "Please enter ddnsapi:"
read apikey
echo "Writting apikey..."
sed -i -e "s/apikey = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/apikey = ${apikey}/g" config.txt
echo "Please enter domain..."
read domain
echo "Writting domain"
sed -i -e "s/domain = example.com/apikey = ${domain}/g" config.txt
echo "Please enter a_name"
read a_name
echo "Writting a_name..."
sed -i -e "s/a_name = raspbian /apikey = ${a_name}/g" config.txt
cat /root/gandi-ddns/config.txt
