#!/bin/bash

# updates, prereqs
apt-get -y update
apt-get -y upgrade
apt-get -y install git
apt-get -y autoremove

# install topology_proxy_app
git clone https://github.com/ebob9/topology_proxy_app.git

# install stage2 items
pip install -r topology_proxy_app/requirements.txt

# myself cleanup
rm ./build_container.sh
