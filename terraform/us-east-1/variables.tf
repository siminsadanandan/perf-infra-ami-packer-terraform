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

variable "instance_count" {
  description = "No of instances to provision"
  default     = "1"
}

variable "aws_key_name" {
  default = "perfuser"
}

variable "public_key_path" {
  default = "/Users/sisadana/Documents/my-home/simKey.pub"
}

variable "private_key_path" {
  default = "/Users/sisadana/Documents/my-home/simKey.pem"
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

variable "newrelic_account_id" {
  description = "Newrelic account id"
  default     = "DUMMYID"
}

variable "newrelic_api_key" {
  description = "Newrelic api key"
  default     = "DUMMYKEY"
}

variable "root_vol_size_in_gb" {
  description = "Root volume size in GB"
  default     = "40"
}

variable "root_vol_type" {
  description = "Root volume type gp2(1:3 GB:IOPS), so if you have lot of file read operations from disk consider increasing the disk volume size or moving to provisioned IOPS volume type io2"
  default     = "gp2"
}

variable "loadgen_type" {
  description = "Load generator type k6/jmeter etc"
  default     = "K6"
}
