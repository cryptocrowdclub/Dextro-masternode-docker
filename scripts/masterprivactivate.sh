#!/bin/bash
while inotifywait -e modify /var/www/masternodeprivkey/masternodeprivkey.txt; do
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
  docker run -d --name dextromasternode dextromasternode
  docker cp /root/dextro.conf dextromasternode:/root/.dextro/
  docker cp /root/dextro/dextrod dextromasternode:/root/dextro/
  docker commit dextromasternode dextromasternode
  docker container rm dextromasternode
  echo 'loading master node...'
  docker run -d --restart always -p 39320:39320 --name dextromasternode dextromasternode /root/dextro/dextrod -daemon -datadir=/root/.dextro -conf=/root/.dextro/dextro.conf
  #docker stop dextromasternode
  docker start dextromasternode
  systemctl stop apache2
  systemctl disable apache2
  ufw delete allow 443/tcp
  break 
done
