#!/usr/bin/env bash
set -e

# Get gpg keys, which allow us to securely download
# all of our packages.
gpg --keyserver keys.gnupg.net --recv 886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -

# Upgrade packages
sudo apt-get --yes update
sudo apt-get --yes  upgrade

# Install pip3 for python3
sudo apt install --yes python3-pip

# Python packages
# Virualenv will allow us to create a
# nicely wrapped environment for Python
sudo pip3 install virtualenv

# sudo virtualenv --always-copy venv

# Install Tor
echo 'deb https://deb.torproject.org/torproject.org bionic main' | sudo tee -a /etc/apt/sources.list.d/torproject.list
echo 'deb-src https://deb.torproject.org/torproject.org bionic main' | sudo tee -a /etc/apt/sources.list.d/torproject.list
sudo apt update
sudo apt install --yes tor
sudo apt install --yes tor deb.torproject.org-keyring

# Start Tor as a service
# This means that Tor will run in the background
# and will be available on port 9050
sudo service tor start


echo "Provision successful."