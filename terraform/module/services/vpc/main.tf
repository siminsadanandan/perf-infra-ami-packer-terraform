############
# MODULE: VPC provisioning
# module input params defined in module specific variable.tf file 
# output value are defined in output.tf file 
resource "aws_vpc" "perf-loadgen" {
  cidr_block = var.vpc_cidr
  #enable_dns_hostnames = true
  #enable_dns_support = true

  tags = {
    Owner       = var.owner
    Terraform   = true
    Environment = var.environment
    Name        = "perf-loadgen-vpc"
  }
}
