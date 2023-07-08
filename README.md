# Distributed load generation AWS infra setup automation

This infrastructure code helps to quickly setup required load generation infra in AWS cloud. Deployment script gives you option to create on-demand infra in multiple AWS AZ/region and once the test is complete it can be teared down completely. With this you can quickly setup a multi-geo distributed test using load generation tool of your choice. As part of this setup you will deploy 1 EC2 instance per AZ/region and by default the instance is provisioned in an private subnet. Outbound/internet access for these VMs are managed through NAT Gateway deployed in the public subnet. An elastic public IP is created and associated to the NAT Gateway. User also have option to create 7 more public IPs and associate to the NAT Gateway if you need to generate load from multiple IP addresses. 

`If you want to ssh to your load generator m/c you have to provision a jumphost/bastion host in the public subnet sharing the same VPC and then ssh ProxyJump to your load generator VM through the jumphost/bastion host.`

```bash
ssh -o StrictHostKeyChecking=accept-new -J ubuntu@<jumphost IP> ubuntu@<load generator VM IP>

```

The deployment script are organized into 2 main folder, all the AMI creation/deployment done using ***packer.io*** scripts are under *packer* folder and the AWS infrastructure provisioning done using **terraform.io** are under *terraform* folder. Inside terraform folder configurations for each AZ/region are again separated into multiple subfolder with AZ name as folder name. 

*Note the current deployment don't have option to store any logs to a persistent store like s3/nfs etc.* 


### Packer scripts for AMI creation

Run the AMI *build.sh* script from packer folder which refer the main build file *perf_ubuntu_docker_ami.pkr.hcl*. This will build an Ubuntu 22 based image along with some system monitoring tools like htop, nmon, net-tools etc. The image also have docker CE and other pre requisite installed through the script *prereq_install.sh*. As part of this image building we also apply required OS level tunings for load generator using script *perf_tunings.sh*.

Once the image is created it will be available only in the region you have build it. If you want to make the image available in other regions then you want to add the required region in the list item under variable *_ami_regions_* in the main build script *perf_ubuntu_docker_ami.pkr.hcl*.

*Note AWS AMI image will incur some storage cost


### Terraform AWS infrastructure creation code

For the ease of maintaining multi-region deployment script. we have separate *main .tf* script and associated *variable.tf* file for each region organized in respective folder. All the common script for object creations are separated out into common *module* folder. Before you run the script you are required to update the *variable.tf* file from the respective region folder. 

Verify these parameters are updated correctly before you run the script...
- aws_region (update the correct aws region code)
- ami_owner (you can get the AMI owner details from the AMI info page)
- instance_type (AWS EC2 instance type name)
- public_key_path (ssh key's public part, provide name with full path, you require the private part of this key to connect to your EC2 instance)


All the post VM provisioning tasks are defined in template *pre_test_setup.tftpl*, the bash script defined get executed as part of the VM provisioning cloud_init step. Template script have conditional block to execute separate steps in bastion and load generator hosts. The sample template provided install newrelic K6.io integration agent, download and setup K6.io load generator and start a dry load test with the downloaded sample K6.io script.


To deploy the infra, you can run the *deploy.sh* script found under the *terraform* folder. If you have added new region then the script needs to be updated to deploy that region as well. 


`You are required to pass the AWS credential to the terraform CLI, you can export AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY as env variable to make it available to the terraform code`


`Additional terraform scripts can access the exported environment variable with in scripts if it follow specific naming pattern TF_VAR_{variable name}. Example - to pass the Newrelic account id and key as environment variable you have to export TF_VAR_newrelic_account_id="xx" and export TF_VAR_newrelic_api_key="yy" and these variables have to be declared in the main *variable.tf* file for the *main.tf* to access it.`

### Customizing the deployment

- To add new region you are required to create a new folder e.g. *us-west-1* and under that folder copy *main.tf* and *variable.tf* from existing *us-east-1* folder. Most of the time you are required to change only the *aws_region* parameter in the *variable.tf* file to ready the deployment. 

- If you want to deploy multiple EC2 instances per region then change the *instance_count* value in the *variable.tf* file.
