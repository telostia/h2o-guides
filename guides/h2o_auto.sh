#!/bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install git -y
sudo apt-get install nano -y
sudo apt-get install curl -y
sudo apt-get install pwgen -y
sudo apt-get install wget -y
sudo apt-get install build-essential libtool automake autoconf -y
sudo apt-get install autotools-dev autoconf pkg-config libssl-dev -y
sudo apt-get install libgmp3-dev libevent-dev bsdmainutils libboost-all-dev -y
sudo apt-get install libzmq3-dev -y
sudo apt-get install libminiupnpc-dev -y
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get update -y
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
#get ip lib
sudo apt install libwww-perl -y

cd
#get wallet files
wget https://raw.githubusercontent.com/telostia/vetani2-guides/master/wallet/linux/vetani_linux.tar.gz
tar -xvf vetani_linux.tar.gz
rm vetani_linux.tar.gz vetani_auto.sh
chmod +x vetani*
cp vetani* /usr/local/bin
ufw allow 1977/tcp

#masternode input

echo -e "${GREEN}Now paste your Masternode key by using right mouse click and press ENTER ${NONE}";
read MNKEY

EXTIP=`lwp-request -o text checkip.dyndns.org | awk '{ print $NF }'`
PASSW=`pwgen -1 20 -n`

echo -e "${GREEN}Preparing config file ${NONE}";

rm -rf $HOME/.vetani
sudo mkdir $HOME/.vetani

printf "addnode=140.82.11.216:38221\naddnode=149.28.178.170:38221\naddnode=209.250.241.120:38221\naddnode=185.162.130.170:38221\naddnode=85.25.94.7:38221\naddnode=5.9.180.148:38221\naddnode=95.179.140.249:38221\naddnode=104.237.149.64:38221\naddnode=185.233.105.172:38221\naddnode=45.76.146.140:38221\naddnode=185.53.191.78:38221\n\nrpcuser=vetani432345$PASSW\nrpcpassword=$PASSW\nrpcport=1977\nrpcallowip=127.0.0.1\ndaemon=1\nlisten=1\nserver=1\nmaxconnections=256\nexternalip=$EXTIP:38221\nmasternode=1\nmasternodeprivkey=$MNKEY" >  $HOME/.vetani/vetani.conf


vetanid -daemon
watch vetani-cli getinfo

