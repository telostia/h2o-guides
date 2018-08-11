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

sudo cd
#get wallet files
sudo wget https://raw.githubusercontent.com/telostia/h2o-guides/master/wallet/linux/h2o-linux.tar.gz
sudo tar -xvf h2o-linux.tar.gz
sudo rm h2o-linux.tar.gz
sudo rm h2o_auto.sh
sudo chmod +x h2o*
sudo cp h2o* /usr/local/bin
sudo ufw allow 13355/tcp

#masternode input

echo -e "${GREEN}Now paste your Masternode key by using right mouse click and press ENTER ${NONE}";
read MNKEY

EXTIP=`curl -s4 icanhazip.com`
USER=`pwgen -1 20 -n`
PASSW=`pwgen -1 20 -n`

echo -e "${GREEN}Preparing config file ${NONE}";

#copy wallet.da to /root incase it is being used as a pos on vps...
sudo cp $HOME/.h2ocore/wallet.dat /root/
sudo rm -rf $HOME/.h2ocore
sudo mkdir $HOME/.h2ocore

printf "addnode=108.61.219.28:13355\naddnode=140.82.52.45:13355\naddnode=104.207.145.111:13355\naddnode=80.210.127.1:13355\naddnode=80.210.127.2:13355\naddnode=80.210.127.3:13355\n\nrpcuser=h2o$USER\nrpcpassword=$PASSW\nrpcport=13356\nrpcallowip=127.0.0.1\ndaemon=1\nlisten=1\nserver=1\nmaxconnections=256\nexternalip=$EXTIP:13355\nmasternode=1\nmasternodeprivkey=$MNKEY" >  $HOME/.h2ocore/h2o.conf


h2od -daemon
watch h2o-cli getinfo

