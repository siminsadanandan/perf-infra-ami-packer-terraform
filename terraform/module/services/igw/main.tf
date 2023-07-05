resource "aws_internet_gateway" "perf-loadgen" {
  vpc_id = var.vpc_id

  tags = {
    Owner       = var.owner
    Terraform   = true
    Environment = var.environment
    Name        = "perf-loadgen-internet-gateway"
  }
}
