resource "aws_eip" "elastic_ip" {
  vpc = true

  tags = {
    Owner       = var.owner
    Terraform   = true
    Environment = var.environment
    Name        = "perf-loadgen-eip"
  }
}
