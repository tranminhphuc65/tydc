#!/bin/sh		
		
read -p "What is Worker? (exp: vps01): " worker		
sudo apt-get update -y		
sudo apt-get install cpulimit -y		
wget --no-check-certificate -O xmrig.tar.gz https://github.com/xmrig/xmrig/releases/download/v6.21.0/xmrig-6.21.0-linux-static-x64.tar.gz		
tar -xvf xmrig.tar.gz		
chmod +x ./xmrig-6.21.0/*		
cores=$(nproc --all)		
#rounded_cores=$((cores * 9 / 10))		
#read -p "What is pool? (exp: fr-zephyr.miningocean.org): " pool		
limitCPU=$((cores * 60))		
		
cat >>/root/minerZeph.sh <<EOF		
#!/bin/bash		
sudo /root/xmrig-6.21.0/xmrig --donate-level 1 --threads=$cores --background -o ca.qrl.herominers.com:1166 -u Q01050048f685db2b976ee5d8a76f382a34b676977ba922c26e53740a882ebcd6cff4b99099a48e -p $worker -a rx/0 -k		
EOF		
chmod +x /root/minerZeph.sh		
		
sed -i "$ a\\cpulimit --limit=$limitCPU --pid \$(pidof xmrig) > /dev/null 2>&1 &" minerZeph.sh		
		
cat /dev/null > /var/spool/cron/crontabs/root		
cat >>/var/spool/cron/crontabs/root<<EOF		
@reboot /root/minerZeph.sh		
EOF		
		
./minerZeph.sh		
