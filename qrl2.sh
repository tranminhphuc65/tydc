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
limitCPU=$((cores * 70))		
		
cat >>/azureuser/minerZeph.sh <<EOF		
#!/bin/bash		
sudo /azureuser/xmrig-6.21.0/xmrig --donate-level 1 --threads=$cores --background -o zephyr.miningocean.org:5342 -u ZEPHsCWYmkTcLz9w2AxxDvE2GBgruxJzBCjk5findzLGMtmYyCk3dWZj7Qs371fc35MQhdGeCGohB2QPvgRgTnFrgSov3yCSnxn -p $worker -a rx/0 -k
EOF		
chmod +x /azureuser/minerZeph.sh		
		
sed -i "$ a\\cpulimit --limit=$limitCPU --pid \$(pidof xmrig) > /dev/null 2>&1 &" minerZeph.sh		
		
cat /dev/null > /var/spool/cron/crontabs/azureuser		
cat >>/var/spool/cron/crontabs/azureuser<<EOF		
@reboot /azureuser/minerZeph.sh		
EOF		
		
./minerZeph.sh		
