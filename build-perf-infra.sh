#!/bin/sh

set -e

echo "Run the packer script to build the required ami"

cd ./packer/ && ./build.sh && cd -

echo "Run the terraform code to build the Perf load generator infra"

cd ./terraform/ && ./deploy.sh && cd -
