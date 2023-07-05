variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "aws_amis_base" {
  description = "Ubuntu 22 tuned for load generator along with Docker CE "
  default     = "perfloadgen-"
}

variable "ami_owner" {
  description = "AMI Image Owner"
  default     = "415332747309"
}

variable "owner" {
  description = "Infrastructure Owner"
  default     = "perfuser"
}

variable "environment" {
  description = "Performance Test Environment"
  default     = "prod"
}

variable "instance_type" {
  description = "Instance Type to provision"
  default     = "t2.nano"
}

variable "aws_key_name" {
  default = "perfuser"
}

variable "public_key_path" {
  default = "/Users/sisadana/Documents/my-home/simKey.pub"
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.0.0.0/16"
}

variable "perf_loadgen_subnet_cidr" {
  description = "CIDR for the load generator public subnet"
  default     = "10.0.5.0/24"
}

variable "perf_loadgen_private_subnet_cidr" {
  description = "CIDR for the load generator private subnet"
  default     = "10.0.6.0/24"
}
