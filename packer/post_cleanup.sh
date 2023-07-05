#!/bin/bash

# Cleanup AMI after docker installation and applying perf tunings

set -e

echo 'Executing clean up script...'
sudo apt-get -y autoremove
sudo apt-get -y clean
#sudo rm -rf /tmp/*
cat /dev/null > ~/.bash_history
history -c
exit
