# Distributed load generation AWS infra setup automation

This infrastructure code helps to quickly setup required load generation infra in AWS cloud. Deployment script gives you option to create on-demand infra and once the test is complete it can be teared down completely. With this you can setup a multi-geo distributed test using load generation tool of your choice. As part of this setup you will deploy 1 EC2 instance per region and by default the instance is provisioned in an private subnet. Outbound/internet access for these VMs are managed through NAT Gateway deployed in the public subnet. An elastic public IP is created and associated to the NAT Gateway. User also have option to create 7 more public IPs and associate to the NAT Gateway if you need to generate load from multiple IP addresses. 

If you want to ssh to your load generator m/c you have to create a jumphost/bastion host with public IP sharing the same VPC and ssh tunnel to your load generator VM.

*Note the current deployment don't have option to store any logs to a persistent store like s3/nfs etc.* 



### Packer scripts for AMI creation

Run the AMI build.sh script from packer folder, the main build file is perf_ubuntu_docker_ami.pkr.hcl. This will build an Ubuntu 22 based image along with some system monitoring tools like htop, nmon, net-tools etc. This image also have docker CE installed and other pre requisite installed through the script prereq_install.sh. As part of this image building we also apply required OS level tunings for load generator, all the tuning can be found in script perf_tunings.sh.

Once the image is created it will be available only in the region you have build it. If you want to make the image available in other regions also then you want to add the required region in the list item under variable _ami_regions_

*Note AMI image will incur some storage cost


### Terraform AWS infrastructure creation code

For the ease of maintaining multi-region deployment script. we have separate main .tf script and associated variable.tf file for each region organized in respective folder. All the common script for object creations are separated out into common module. Before you run the script you are required to update the variable.tf file from the respective region folder. 

Verify these parameters are updated correctly before you run the script...
- aws_region (update the correct aws region code)
- ami_owner (you can get the AMI owner details from the AMI info page)
- instance_type (aws EC2 instance type name)
- public_key_path (ssh key's public part, name with full path, you require the private part of this key to connect to your EC2 instance)


To add new region you are required to create a new folder e.g. us-west-1 and under that folder copy main.tf and variable.tf from existing us-east-1 folder. Most of the time you are required to change only the aws_region parameter in the variable.tf file to ready the deployment. 

To deploy the infra, you can run the deploy.sh script found under the *terraform* folder. If you have added new region then the script needs to be updated to deploy that region as well. 


`To pass the AWS credential you can export AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY as env variable`