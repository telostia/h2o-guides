#!/bin/bash
if [ $(id -u) -ne 0 ]
then
  SUDO='sudo'
else
  SUDO=''
fi

echo "Installing required packages";

#Swap part
$SUDO dd if=/dev/zero of=/mnt/myswap.swap bs=1M count=4000
$SUDO mkswap /mnt/myswap.swap
$SUDO chmod 0600 /mnt/myswap.swap
$SUDO swapon /mnt/myswap.swap

$SUDO apt-get update -y
$SUDO apt-get upgrade -y
$SUDO apt-get dist-upgrade -y
$SUDO apt-get install git -y
$SUDO apt-get install curl -y
$SUDO apt-get install nano -y
$SUDO apt-get install wget -y
$SUDO apt-get install -y pwgen
$SUDO apt-get install build-essential libtool automake autoconf -y
$SUDO apt-get install autotools-dev autoconf pkg-config libssl-dev -y
$SUDO apt-get install libgmp3-dev libevent-dev bsdmainutils libboost-all-dev -y
$SUDO apt-get install libzmq3-dev -y
$SUDO apt-get install libminiupnpc-dev -y
$SUDO add-apt-repository ppa:bitcoin/bitcoin -y
$SUDO apt-get update -y
$SUDO apt-get install libdb4.8-dev libdb4.8++-dev -y
$sudo apt install libwww-perl -y

echo "Done installing";
YOURIP=`lwp-request -o text checkip.dyndns.org | awk '{ print $NF }'`
PSS=`pwgen -1 20 -n`

cd $HOME
echo "Getting H2O client";
mkdir $HOME/h2o
git clone https://github.com/h2oproject/h2o.git h2o
cd $HOME/h2o
chmod 777 autogen.sh
./autogen.sh
./configure --disable-tests --disable-gui-tests
chmod 777 share/genbuild.sh
$SUDO make
$SUDO make install

echo "In order to proceed with the installation, please paste Masternode genkey by clicking right mouse button. Once masternode genkey is visible in the terminal please hit ENTER.";
read MNKEY


mkdir $HOME/.h2ocore

printf "rpcuser=user\nrpcpassword=$PSS\nrpcallowip=127.0.0.1\nmaxconnections=500\ndaemon=1\nserver=1\nlisten=1\nrpcport=13356\nexternalip=$YOURIP:13355\nmasternodeprivkey=$MNKEY\nmasternode=1\n\naddnode=35.194.239.227:13355\naddnode=45.77.237.216:13355\naddnode=80.211.1.207:13355\naddnode=94.177.180.162:13355\naddnode=173.249.45.137:13355\naddnode=185.243.54.32:13355\naddnode=45.76.4.42:13355\naddnode=104.236.77.15:13355\naddnode=163.172.155.150:13355\naddnode=194.87.110.162:13355" > /$HOME/.h2ocore/h2o.conf

echo "Starting H2O client";
h2od --daemon
sleep 5
echo "Syncing...";
until h2o-cli mnsync status | grep -m 1 '"IsSynced": true'; do sleep 1 ; done > /dev/null 2>&1
echo "Sync complete. You masternode is running!! you can start your masternode later with: h2od --daemon";111
echo "You can stop your masternode with: h2o-cli stop"