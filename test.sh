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
if [[ ${is_auto} != "y" ]]; then
	echo "Press Y for continue the installation process, or press any key else to exit."
	read is_install
	if [[ ${is_install} != "y" && ${is_install} != "Y" ]]; then
    	echo -e "Installation has been canceled..."
    	exit 0
	fi
fi
cd /root/gandi-ddns
do_ddnsapi(){
		echo -n "Please enter ddnsapi:"
		read ddnsapi
		echo "Writting MU config..."
	sed -i -e "s/apikey = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/apikey = '${ddnsapi}'/g" config.txt
}
