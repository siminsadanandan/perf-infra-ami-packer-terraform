############
# MODULE: elastic IP provisioning
# module input params defined in module specific variable.tf file 
# output value are defined in output.tf file 
resource "aws_eip" "elastic_ip" {
  vpc = true

  tags = {
    Owner       = var.owner
    Terraform   = true
    Environment = var.environment
    Name        = "perf-loadgen-eip"
  }
}
