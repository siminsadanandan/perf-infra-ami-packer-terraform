############
# MODULE: All Network components (subnet/route table/route etc.) provisioning
# module input params defined in module specific variable.tf file 
# output value are defined in output.tf file 
data "aws_availability_zones" "available" {}

# create a public subnet to attach public facing resources like NAT Gateway
# webserver, bastion host etc
resource "aws_subnet" "perf-loadgen-public-sn" {
  vpc_id     = var.vpc_id
  cidr_block = var.perf_loadgen_subnet_cidr
  #availability_zone = data.aws_availability_zones.available.names[0]

  map_public_ip_on_launch = true

  tags = {
    Owner       = var.owner
    Terraform   = true
    Environment = var.environment
    Name        = "perf-loadgen-subnet-public"
  }
}

# create a private subnet to attach to all the backend resources
resource "aws_subnet" "perf-loadgen-private-sn" {
  vpc_id     = var.vpc_id
  cidr_block = var.perf_loadgen_private_subnet_cidr
  #availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Owner       = var.owner
    Terraform   = true
    Environment = var.environment
    Name        = "perf-loadgen-subnet-private"
  }
}

# create a public route table to associate to the public subnet, Internet Gateway
resource "aws_route_table" "perf-loadgen-route-table-public" {
  vpc_id = var.vpc_id
  tags = {
    Owner       = var.owner
    Terraform   = true
    Environment = var.environment
    Name        = "perf-loadgen-route-table-public"
  }
}

# create a private route table to associate to the private subnet, NAT Gateway
resource "aws_route_table" "perf-loadgen-route-table-private" {
  vpc_id = var.vpc_id
  tags = {
    Owner       = var.owner
    Terraform   = true
    Environment = var.environment
    Name        = "perf-loadgen-route-table-private"
  }
}

# Associate public route table to public subnet 
resource "aws_route_table_association" "perf-loadgen-route-table-asso-public" {
  subnet_id      = aws_subnet.perf-loadgen-public-sn.id
  route_table_id = aws_route_table.perf-loadgen-route-table-public.id
}

# Associate private route table to private subnet 
resource "aws_route_table_association" "perf-loadgen-route-table-asso-private" {
  subnet_id      = aws_subnet.perf-loadgen-private-sn.id
  route_table_id = aws_route_table.perf-loadgen-route-table-private.id
}

# Add routing rules to allow traffic to a specific network/IP range
# destination 0.0.0.0/0 which allow all the IPs address range including public range to be
# routed through the Internet Gateway. This rule is added to a public subnet so server attached
# to that subnet alone will have this route
resource "aws_route" "perf-loadgen-route-public" {
  route_table_id         = aws_route_table.perf-loadgen-route-table-public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.gateway_id
}

# Add routing rules to allow traffic to a specific network/IP range
# destination 0.0.0.0/0 which allow all the IPs address range including public range to be
# routed through the NAT Gateway. This rule is added to the private subnet so server attached
# to that subnet alone will have this route
resource "aws_route" "perf-loadgen-route-private" {
  route_table_id         = aws_route_table.perf-loadgen-route-table-private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_id
}
