############
# MODULE: server provisioning
# module input params defined in module specific variable.tf file 
# output value are defined in output.tf file 
resource "aws_instance" "perf-loadgen" {
  ami           = data.aws_ami.perf-loadgen.id
  instance_type = var.instance_type

  # if you want to always deploy in the 1st AZ uncomment this option 
  # availability_zone = data.aws_availability_zones.available.names[0]

  # No. of instances to spin off
  count = var.instance_count

  key_name                    = var.key_name
  vpc_security_group_ids      = [var.vpc_security_group_ids]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = var.iam_instance_profile_id
  # Uncomment below line for spot instance option
  /*
  instance_market_options {
    spot_options {
      max_price = 0.0031
    }
  }
*/

  # root disk
  root_block_device {
    volume_size           = var.root_vol_size_in_gb
    volume_type           = var.root_vol_type
    encrypted             = false
    delete_on_termination = true
  }

  # uncomment below block if you want to attach separate volume in addition
  # to the above root volume
  /*
  # data disk
  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = "50"
    volume_type           = "gp2"
    delete_on_termination = true
  }
*/

  # execute server init script/pre_test_setup shell script 
  user_data = templatefile("${path.module}/pre_test_setup.tftpl", { OPT = var.loadgen_type, NEWRELIC_ACCOUNT_ID = var.newrelic_account_id, NEWRELIC_KEY = var.newrelic_api_key, HOSTNAME = "${var.hostname_prefix}-${count.index}" })

  /*
  provisioner "file" {
    source      = "${path.module}/pre_test_setup.sh"
    destination = "/tmp/pre_test_setup.sh"
    connection {
      type     = "ssh"
      user     = "ubuntu"
      host     = self.private_ip
      private_key = file(var.private_key_path)
      bastion_host = self.public_ip
      bastion_user = "ubuntu"
      bastion_host_key = file(var.public_key_path)
      bastion_private_key = file(var.private_key_path)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/pre_test_setup.sh",
      "/tmp/pre_test_setup.sh ${var.loadgen_type} ${var.newrelic_account_id} ${var.newrelic_api_key}"
    ]
       connection {
      type     = "ssh"
      user     = "ubuntu"
      host     = self.public_ip
      private_key = file(var.private_key_path)
      bastion_host = self.public_ip
      bastion_user = "ubuntu"
      bastion_host_key = file(var.public_key_path)
      bastion_private_key = file(var.private_key_path)
    }
  }
*/

  tags = {
    Owner       = var.owner
    Terraform   = true
    Environment = var.environment
    Name        = "perf-loadgen-instance-${count.index}"
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
