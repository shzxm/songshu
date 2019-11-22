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
cd /root
git clone https://github.com/shzxm/gandi-ddns.git
cd /root/gandi-ddns
pip install -r requirements.txt
cp config-template.txt config.txt
echo -n "Please enter apikey:"
read apikey
echo "Writting apikey..."
sed -i -e "s/apikey = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/apikey = ${apikey}/g" config.txt
echo "Please enter domain:"
read domain
echo "Writting domain..."
sed -i -e "s/domain = example.com/domain = ${domain}/g" config.txt
echo "Please enter a_name:"
read a_name
echo "Writting a_name..."
sed -i -e "s/a_name = raspbian/a_name = ${a_name}/g" config.txt
cat /root/gandi-ddns/config.txt
echo "Writting system config..."
wget -O ssr.service https://raw.githubusercontent.com/shzxm/songshu/master/ssr.service.el7
chmod 754 ssr.service && mv ssr.service /usr/lib/systemd/system
echo "@reboot python /root/gandi-ddns/gandi_ddns.py &" >> /var/spool/cron/root
echo "Starting SSR Node Service..."
systemctl enable ssr && systemctl start ssr
