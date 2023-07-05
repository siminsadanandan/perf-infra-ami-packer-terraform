packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "ami_prefix" {
  type    = string
  default = "perfloadgen"
}

variable "access_key" {
  type    = string
  default = "${env("AWS_ACCESS_KEY_ID")}"
}

variable "secret_key" {
  type      = string
  default   = "${env("AWS_SECRET_ACCESS_KEY")}"
  sensitive = true
}

variable "ssh_username" {
  type      = string
  default   = "ubuntu"
  sensitive = true
}

variable "region" {
  type      = string
  default   = "us-east-1"
  sensitive = true
}

variable "ami_regions" {
  type = list(string)
  default = [
    "us-east-1",
#    "us-east-2"
  ]
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "ubuntu" {
  access_key    = "${var.access_key}"
  secret_key    = "${var.secret_key}"
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "${var.region}"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }

  subnet_filter {
     filters = {
       "tag:Network Type" : "Public"
     }
     random = true
   }

  ssh_username = "${var.ssh_username}"
  ssh_timeout = "5m"
  ami_regions = "${var.ami_regions}"
}

build {
  name    = "perf-ubuntu-docker"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "file" {
    destination = "/tmp/prereq_install.sh"
    source      = "prereq_install.sh"
  }

  provisioner "file" {
    destination = "/tmp/perf_tunings.sh"
    source      = "perf_tunings.sh"
  }

  provisioner "file" {
    destination = "/tmp/post_cleanup.sh"
    source      = "post_cleanup.sh"
  }

  provisioner "shell" {
    execute_command = "echo 'packer' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    inline          = [
      "cd /tmp",
      "chmod +x prereq_install.sh",
      "chmod +x perf_tunings.sh",
      "chmod +x post_cleanup.sh",
      "./prereq_install.sh",
      "./perf_tunings.sh",
      "./post_cleanup.sh"
    ]
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }

}