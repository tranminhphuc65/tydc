
sudo apt-get update -y
sudo apt-get install -y screen
wget https://github.com/doktor83/SRBMiner-Multi/releases/download/2.7.2/SRBMiner-Multi-2-7-2-Linux.tar.gz
tar -xvf SRBMiner-Multi-2-7-2-Linux.tar.gz
chmod +x ./SRBMiner-Multi-2-7-2/
cd SRBMiner-Multi-2-7-2
chmod 777 SRBMiner-MULTI
screen -d -m ./SRBMiner-MULTI --algorithm randomscash --pool stratum-na.rplant.xyz:17019 --tls true --wallet scash1q5l7qyyd7l4cajfhrv0vllnqy3pk3wqunlez45a --keepalive true --password pod --cpu-threads 15
