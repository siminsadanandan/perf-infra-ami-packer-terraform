resource "aws_nat_gateway" "nat_gateway" {
  # associate elastic ip
  allocation_id = var.allocation_id
  subnet_id = var.subnet_id
  # upto 7 secondary IPs can be associated
  #  secondary_allocation_ids = []

  tags = {
    Owner       = var.owner
    Terraform   = true
    Environment = var.environment
    Name        = "perf-loadgen-natgw"
  }
}
