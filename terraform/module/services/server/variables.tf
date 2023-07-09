variable "owner" {
  description = "Infrastructure Owner"
}

variable "ami_owner" {
  description = "AMI Image Owner"
}

variable "environment" {
  description = "Performance Test Environment"
}

variable "instance_type" {
  description = "Instance Type to provision"
}

variable "aws_amis_base" {
  description = "Ubuntu 22 tuned for load generator along with Docker CE "
}

variable "key_name" {
  description = "Key pair id"
}

variable "vpc_id" {
  description = "VPC Id from vpc object/module"
}

variable "subnet_id" {
  description = "Subnet Id from your network object/module"
}

variable "vpc_security_group_ids" {
  description = "Security group id"
}

variable "instance_count" {
  description = "No of instances to provision"
}

variable "associate_public_ip_address" {
  description = "Assign public ip to the instance true/false"
}

variable "newrelic_account_id" {
  description = "Newrelic account id"
}

variable "newrelic_api_key" {
  description = "Newrelic api key"
}

variable "root_vol_size_in_gb" {
  description = "Root volume size in GB"
}

variable "root_vol_type" {
  description = "Root volume type"
}

variable "loadgen_type" {
  description = "Load generator type k6/jmeter"
}

variable "hostname_prefix" {
  description = "Server hostname prefix"
}

variable "iam_instance_profile_id" {
  description = "IAM Instance profile Id"
}

