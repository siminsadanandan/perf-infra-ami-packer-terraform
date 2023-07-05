variable "perf_loadgen_subnet_cidr" {
  description = "CIDR for the load generator public subnet"
}

variable "perf_loadgen_private_subnet_cidr" {
  description = "CIDR for the load generator private subnet"
}

variable "owner" {
  description = "Infrastructure Owner"
}

variable "environment" {
  description = "Performance Test Environment"
}

variable "vpc_id" {
  description = "VPC Id from vpc object/module"
}

variable "route_table_id" {
  description = "Main route table Id from vpc object/module"
}

variable "gateway_id" {
  description = "Gateway Id from igw object/module"
}

variable "nat_gateway_id" {
  description = "NAT Gateway Id from natgw object/module"
}
