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

# perf-loadgen instance
resource "aws_instance" "perf-loadgen" {
  ami               = data.aws_ami.perf-loadgen.id
  instance_type     = var.instance_type
  availability_zone = data.aws_availability_zones.available.names[0]

  # No. of instances to spin off
  count = "1"

  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.perf-loadgen.id]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = false

  /*
  # root disk
  root_block_device {
    volume_size           = "20"
    volume_type           = "gp2"
    encrypted             = false
    delete_on_termination = true
  }
  # data disk
  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = "50"
    volume_type           = "gp2"
    delete_on_termination = true
  }

*/

  /*
# Script execution on deployment
  user_data = <<-EOL
  #!/bin/bash -xe
  apt update
  apt install openjdk-8-jdk --yes
  EOL
*/

  tags = {
    Owner       = var.owner
    Terraform   = true
    Environment = var.environment
    Name        = "perf-loadgen-instance"
  }
}

data "aws_ami" "perf-loadgen" {
  most_recent = true
  owners      = [var.ami_owner]
  filter {
    name   = "name"
    values = ["${var.aws_amis_base}*"]
  }
}

data "aws_availability_zones" "available" {}
