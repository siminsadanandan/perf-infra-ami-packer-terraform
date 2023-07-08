############
# MODULE: Internet Gateway provisioning
# module input params defined in module specific variable.tf file 
# output value are defined in output.tf file 
resource "aws_internet_gateway" "perf-loadgen" {
  vpc_id = var.vpc_id

  tags = {
    Owner       = var.owner
    Terraform   = true
    Environment = var.environment
    Name        = "perf-loadgen-internet-gateway"
  }
}
