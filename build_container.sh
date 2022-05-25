#!/usr/bin/env bash
# ensure app dir
cd /app/

# updates, prereqs
apt-get -y update
apt-get -y upgrade
apt-get -y install git apache2-utils
apt-get -y autoremove

# install topology_proxy_app
git clone https://github.com/ebob9/topology_proxy_app.git

# install stage2 items
pip install -r topology_proxy_app/requirements.txt

# create TLS dir for simple NGINX certs (app.crt and app.key)
mkdir -p /app/tls

# myself cleanup
rm ./build_container.sh
