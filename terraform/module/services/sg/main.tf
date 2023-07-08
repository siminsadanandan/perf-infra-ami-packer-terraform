############
# MODULE: security group provisioning
# module input params defined in module specific variable.tf file 
# output value are defined in output.tf file 
resource "aws_security_group" "perf-loadgen" {
  name        = "security-group-perf-loadgen"
  description = "Security group for perf-loadgen"

  vpc_id = var.vpc_id

  # Allow Inbound connectivity from any IP for SSH/22 port
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all Outbound connectivity
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Owner       = var.owner
    Terraform   = true
    Environment = var.environment
    Name        = "perf-loadgen-security-group"
  }
}
