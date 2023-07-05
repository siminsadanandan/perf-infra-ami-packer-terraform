#!/bin/sh

# deploy the terraform code

set -e


echo "Deployment step init started for DC: us-east-1"

terraform -chdir=/Users/sisadana/Documents/my-home/perf-infra-ami-packer-terraform/terraform/us-east-1 init

echo "Deployment step init started for DC: us-east-2"

terraform -chdir=/Users/sisadana/Documents/my-home/perf-infra-ami-packer-terraform/terraform/us-east-2 init

echo "Deployment step apply started for DC: us-east-1"

terraform -chdir=/Users/sisadana/Documents/my-home/perf-infra-ami-packer-terraform/terraform/us-east-1 apply -auto-approve

#exit 0

#echo "Deployment step apply started for DC: us-east-2"
#
#terraform -chdir=/Users/sisadana/Documents/my-home/perf-infra-ami-packer-terraform/terraform/us-east-2 apply -auto-approve
#
echo "Deployment step destroy started for DC: us-east-1"

terraform -chdir=/Users/sisadana/Documents/my-home/perf-infra-ami-packer-terraform/terraform/us-east-1 destroy -auto-approve

echo "Deployment step destroy started for DC: us-east-2"

terraform -chdir=/Users/sisadana/Documents/my-home/perf-infra-ami-packer-terraform/terraform/us-east-2 destroy -auto-approve
