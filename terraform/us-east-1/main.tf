terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 5.6.2"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

############
# Run the below block if you want to use your existing key for
# connecting to the VM, you have to make sure the public part
# the key is present in the path referenced below
resource "aws_key_pair" "auth" {
  key_name   = var.aws_key_name
  public_key = file(var.public_key_path)
}
############


/*
############
# Run the below block only if you want to dynamically generate new
# key and use it instead of using your own existing key
resource "tls_private_key" "auth" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "auth" {
  key_name = var.aws_key_name
  public_key = tls_private_key.auth.public_key_openssh
}

output "ssh_private_key_pem" {
  value = tls_private_key.auth.private_key_pem
}

output "ssh_public_key_pem" {
  value = tls_private_key.auth.public_key_pem
}
#
############
*/

module "vpc" {
  source      = "../module/services/vpc"
  owner       = var.owner
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
}

module "network" {
  source                           = "../module/services/network"
  owner                            = var.owner
  environment                      = var.environment
  vpc_id                           = module.vpc.vpc_id
  route_table_id                   = module.vpc.main_route_table_id
  perf_loadgen_subnet_cidr         = var.perf_loadgen_subnet_cidr
  perf_loadgen_private_subnet_cidr = var.perf_loadgen_private_subnet_cidr
  gateway_id                       = module.igw.gateway_id
  nat_gateway_id                   = module.natgw.nat_gateway_id
}

module "elasticip" {
  source      = "../module/services/elasticip"
  owner       = var.owner
  environment = var.environment
}

module "natgw" {
  source        = "../module/services/natgw"
  owner         = var.owner
  environment   = var.environment
  allocation_id = module.elasticip.elastic_ip_id
  subnet_id     = module.network.public_subnet_id
  depends_on    = [module.elasticip.aws_eip]
}

module "igw" {
  source      = "../module/services/igw"
  owner       = var.owner
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
}

module "server" {
  source         = "../module/services/server"
  owner          = var.owner
  ami_owner      = var.ami_owner
  environment    = var.environment
  instance_type  = var.instance_type
  instance_count = var.instance_count
  aws_amis_base  = var.aws_amis_base
  key_name       = aws_key_pair.auth.id
  vpc_id         = module.vpc.vpc_id
  subnet_id      = module.network.private_subnet_id
}
