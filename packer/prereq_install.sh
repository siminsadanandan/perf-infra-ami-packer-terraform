#!/bin/sh

# Install Docker CE on Ubuntu Jammy-22.x AMI + performance monitoring
# tools iftop, nmon, net-tools, java8 +
# zip/unzip and AWS CLIv2

# set -e

sudo apt-get remove docker docker-engine

# for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 7EA0A9C3F273FCD8

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get -y upgrade

sudo apt-get install -y docker-ce

sudo groupadd docker
sudo usermod -aG docker ubuntu

sudo systemctl enable docker

# Install monitoring tools
sudo apt-get -y install iftop
sudo apt-get -y install nmon
sudo apt-get -y install net-tools
sudo apt-get -y install openjdk-8-jre-headless
sudo apt-get -y install zip unzip

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install