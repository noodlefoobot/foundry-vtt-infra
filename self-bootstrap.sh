#!/bin/bash 

# updates
sudo su
apt-get update && apt-get upgrade -y

# service account
useradd -m -p FvTTisthebest88# -s /bin/bash foundry
usermod -aG sudo foundry
su - foundry

# packages
sudo curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo apt-key add -
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee -a /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install nodejs caddy unzip -y
sudo npm install pm2 -g

# start and configure pm2
pm2 startup
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u foundry --hp /home/foundry

# dl, install and test foundry
mkdir ~/foundry
wget --output-document ~/foundry/foundryvtt.zip "https://foundryvtt.s3.amazonaws.com/releases/8.255/FoundryVTT-8.255-Setup.exe?AWSAccessKeyId=AKIA2KJE5YZ3EFLQJT6N&Signature=tUxx%2BGgczzCTKuYj90pva6hwC4I%3D&Expires=1639937384"
unzip ~/foundry/foundryvtt.zip -d ~/foundry/
# rm ~/foundry/foundryvtt.zip
mkdir -p ~/foundryuserdata
cd ~
node foundry/resources/app/main.js --dataPath=/home/<user>/foundryuserdata
pm2 start "node /home/foundry/foundry/resources/app/main.js --dataPath=/home/foundry/foundryuserdata" --name foundry
pm2 save

# setup caddy
sudo nano /etc/caddy/Caddyfile
     #update with code from wiki
sudo service caddy restart
nano ~/foundryuserdata/Config/options.json #(update the proxyPort, proxySSL, and hostname parameters)
pm2 restart foundry

# 7. create swapfile 
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo nano /etc/fstab #(paste /swapfile swap swap defaults 0 0)
sudo swapon -a
sudo swapon --show
