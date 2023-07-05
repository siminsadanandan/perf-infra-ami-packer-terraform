#!/bin/sh

# Install Docker CE on Ubuntu Jammy-22.x AMI + performance monitoring
# tools iftop, htop, nmon, net-tools, java

set -e

echo "Create Ubuntu 22 based Perf infra AMI with Docker, Java and other system monitoring tools installed"

packer build -color=false perf_ubuntu_docker_ami.pkr.hcl
