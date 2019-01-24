#!/usr/bin/env bash
set -e

# Upgrade packages
sudo apt-get --yes update
sudo apt-get --yes upgrade

# Install pip3 for python3
sudo apt install --yes --force-yes python3-pip

# Python packages
# Virualenv will allow us to create a
# nicely wrapped environment for Python
sudo pip3 install virtualenv

# Install Tor
echo 'deb [trusted=yes] https://deb.torproject.org/torproject.org bionic main' | sudo tee -a /etc/apt/sources.list.d/torproject.list
echo 'deb-src [trusted=yes] https://deb.torproject.org/torproject.org bionic main' | sudo tee -a /etc/apt/sources.list.d/torproject.list
sudo apt update
sudo apt install --yes --force-yes tor deb.torproject.org-keyring

# Start Tor as a service
# This means that Tor will run in the background
# and will be available on port 9050
sudo service tor start

# Install R
sudo apt-get -y --force-yes install r-base

echo "Provision successful."