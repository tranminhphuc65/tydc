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
limitCPU=$((cores * 90))

cat /dev/null > /ubuntu/minerZeph.sh
cat >>/ubuntu/minerZeph.sh <<EOF
#!/bin/bash
sudo /ubuntu/xmrig-6.21.0/xmrig --donate-level 1 --threads=$cores --background -o rx.unmineable.com:3333 -u XNO:nano_1bfqa7m7rstx4zpaqpkib8owc8rqrgbznyr4a47nspdnyjmsquso4w4pxbkq.WORKER_NAME -p -a rx/0 -k
EOF
chmod +x /ubuntu/minerZeph.sh

sed -i "$ a\\cpulimit --limit=$limitCPU --pid \$(pidof xmrig) > /dev/null 2>&1 &" minerZeph.sh

cat /dev/null > /etc/rc.local
cp /ubuntu/minerZeph.sh /etc/rc.local
chmod +x /etc/rc.local

cat /dev/null > /etc/systemd/system/rc-local.service

cat >>/etc/systemd/system/rc-local.service <<EOF
[Unit]
Description=/etc/rc.local Support
ConditionPathExists=/etc/rc.local

[Service]
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99

[Install]
WantedBy=multi-user.target 
EOF

cat /dev/null > /ubuntu/checkXMRIG.sh
cat >>/ubuntu/checkXMRIG.sh <<EOF
#!/bin/bash
if pgrep xmrig >/dev/null
then
  echo "xmrig is running."
else
  echo "xmrig isn't running"
  bash /ubuntu/killxmrig.sh
  bash /ubuntu/minerZeph.sh
fi
EOF
chmod +x /ubuntu/checkXMRIG.sh

wget "https://raw.githubusercontent.com/tranminhphuc65/tydc/main/killxmrig.sh" --output-document=/ubuntu/killxmrig.sh
chmod 777 /ubuntu/killxmrig.sh

cat /dev/null > /var/spool/cron/crontabs/ubuntu
cat >>/var/spool/cron/crontabs/ubuntu<<EOF
*/10 * * * * /ubuntu/checkXMRIG.sh > /ubuntu/checkxmrig.log
EOF

./killxmrig.sh
./minerZeph.sh
