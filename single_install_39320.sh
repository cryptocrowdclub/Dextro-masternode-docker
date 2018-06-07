#Create 1 docker container for dextro daemon for master node
#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

ufw allow ssh/tcp
ufw limit ssh/tcp
ufw allow 39320/tcp
ufw logging on
ufw --force enable

#build dextro source git
apt install -y software-properties-common && add-apt-repository ppa:bitcoin/bitcoin && apt update && apt upgrade -y && apt install -y build-essential libtool autotools-dev automake pkg-config libssl-dev autoconf && apt install -y pkg-config libgmp3-dev libevent-dev bsdmainutils && apt install -y libevent-dev libboost-all-dev libdb4.8-dev libdb4.8++-dev nano git && apt install -y libminiupnpc-dev libzmq5 libdb-dev libdb++-dev unzip
cd /root
wget https://github.com/JDXOCoin20180520Z/dxo_v1.0.1/raw/master/dextro_ubuntu_16.04_v1.0.1.zip
echo ---------------------------------------------------------------------------
echo ---------------------------------------------------------------------------
echo -e "${GREEN}                                unpacking ...${NOCOLOR}"
echo ---------------------------------------------------------------------------
echo ---------------------------------------------------------------------------
unzip dextro_ubuntu_16.04_v1.0.1.zip
rm dextro_ubuntu_16.04_v1.0.1.zip
mkdir -m755 ~/.dextro
cd dextro
chmod +x dextrod && chmod +x dextro-cli

#building masternode
#cd /root/dextro/src
rm /root/dextro/src/Dockerfile
wget git remote add origin https://raw.githubusercontent.com/telostia/Dextro-masternode-docker/master/dextromasternode/Dockerfile
docker build -t "dextromasternode39320" .

#building the config files
echo ---------------------------------------------------------------------------
echo ---------------------------------------------------------------------------
echo -e "${GREEN}                               creating configs ...${NOCOLOR}"
echo ---------------------------------------------------------------------------
echo ---------------------------------------------------------------------------
touch ~/.dextro/dextro.conf
touch ~/.dextro/masternode.conf
IP=$(curl ipinfo.io/ip)
USERNAME=$(pwgen -s 16 1)
PASSWORD=$(pwgen -s 64 1)
MASTERNODEPRIVKEY=$(</var/www/masternodeprivkey/masternodeprivkey.txt)
echo "rpcuser=$USERNAME" >/root/dextro.conf
echo "rpcpassword=$PASSWORD" >>/root/dextro.conf
echo "server=1" >>/root/dextro.conf
echo "listen=1" >>/root/dextro.conf
echo "port=39320" >>/root/dextro.conf
echo "rpcallowip=127.0.0.1" >>/root/dextro.conf
echo "addnode=140.82.12.172:39320" >>/root/dextro.conf
echo "addnode=45.77.7.58:39320" >>/root/dextro.conf
echo "addnode=96.126.101.142:39320" >>/root/dextro.conf
echo "addnode=80.211.5.23:39320" >>/root/dextro.conf
echo "addnode=104.236.13.159:39320" >>/root/dextro.conf
echo "addnode=104.236.13.159:39320" >>/root/dextro.conf
echo "addnode=104.236.13.159:39320" >>/root/dextro.conf
echo "addnode=seed1.dextro.io" >>/root/dextro.conf
echo "addnode=seed2.dextro.io" >>/root/dextro.conf
echo "addnode=seed3.dextro.io" >>/root/dextro.conf
echo "addnode=seed4.dextro.io" >>/root/dextro.conf
echo "addnode=seed5.dextro.io" >>/root/dextro.conf
echo "addnode=seed6.dextro.io" >>/root/dextro.conf
echo "addnode=seed7.dextro.io" >>/root/dextro.conf
echo "addnode=seed8.dextro.io" >>/root/dextro.conf
echo "maxconnections=16" >>/root/dextro.conf
echo "masternodeprivkey=$MASTERNODEPRIVKEY" >>/root/dextro.conf
echo "masternode=1" >>/root/dextro.conf
echo "masternodeaddr=$IP:39320" >>/root/dextro.conf
#docker stop dextromasternode
docker run -d --name dextromasternode39320 dextromasternode39320
docker cp /root/dextro.conf dextromasternode39320:/root/.dextro/
docker cp /root/dextro/dextrod dextromasternode39320:/root/dextro/
docker commit dextromasternode39320 dextromasternode39320
docker container rm dextromasternode39320
echo 'loading master node...'
docker run -d --restart always -p 39320:39320 --name dextromasternode39320 dextromasternode39320 /root/dextro/dextrod -datadir=/root/.dextro -conf=/root/.dextro/dextro.conf
docker start dextromasternode39320


















