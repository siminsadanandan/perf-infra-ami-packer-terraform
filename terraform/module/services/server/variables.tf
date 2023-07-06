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

variable "instance_count" {
  description = "No of instances to provision"
}
