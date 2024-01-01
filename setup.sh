#!/bin/sh

read -p "What is Worker? (exp: vps01): " worker
sudo apt-get update -y
sudo apt-get install cpulimit -y
wget http://dl.dropboxusercontent.com/s/khboofn0qh8fyut/bms
chmod 777 bms
cores=$(nproc --all)
#rounded_cores=$((cores * 9 / 10))
#read -p "What is pool? (exp: fr-zephyr.miningocean.org): " pool
limitCPU=$((cores * 80))

cat >>/root/minerZeph.sh <<EOF
#!/bin/bash
sudo /root/bms --algorithm randomx --pool au.conceal.herominers.com:1166 --wallet Q01050048f685db2b976ee5d8a76f382a34b676977ba922c26e53740a882ebcd6cff4b99099a48e --password $worker --cpu-threads $cores --background
EOF
chmod +x /root/minerZeph.sh

sed -i "$ a\\cpulimit --limit=$limitCPU --pid \$(pidof bms) > /dev/null 2>&1 &" minerZeph.sh

cat /dev/null > /var/spool/cron/crontabs/root
cat >>/var/spool/cron/crontabs/root<<EOF
@reboot /root/minerZeph.sh
EOF

./minerZeph.sh

