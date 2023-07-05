data "aws_availability_zones" "available" {}

# Create a public subnet for perf-loadgen instances
resource "aws_subnet" "perf-loadgen-public-sn" {
  vpc_id            = var.vpc_id
  cidr_block        = var.perf_loadgen_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  map_public_ip_on_launch = true

  tags = {
    Owner       = var.owner
    Terraform   = true
    Environment = var.environment
    Name        = "perf-loadgen-subnet-public"
  }
}

# Create a private subnet for perf-loadgen instances
resource "aws_subnet" "perf-loadgen-private-sn" {
  vpc_id            = var.vpc_id
  cidr_block        = var.perf_loadgen_private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Owner       = var.owner
    Terraform   = true
    Environment = var.environment
    Name        = "perf-loadgen-subnet-private"
  }
}

resource "aws_route_table" "perf-loadgen-route-table-public" {
  vpc_id = var.vpc_id
  tags = {
    Owner       = var.owner
    Terraform   = true
    Environment = var.environment
    Name        = "perf-loadgen-route-table-public"
  }
}

resource "aws_route_table" "perf-loadgen-route-table-private" {
  vpc_id = var.vpc_id
  tags = {
    Owner       = var.owner
    Terraform   = true
    Environment = var.environment
    Name        = "perf-loadgen-route-table-private"
  }
}

resource "aws_route_table_association" "perf-loadgen-route-table-asso-public" {
  subnet_id      = aws_subnet.perf-loadgen-public-sn.id
  route_table_id = aws_route_table.perf-loadgen-route-table-public.id
}

resource "aws_route_table_association" "perf-loadgen-route-table-asso-private" {
  subnet_id      = aws_subnet.perf-loadgen-private-sn.id
  route_table_id = aws_route_table.perf-loadgen-route-table-private.id
}

# Public route config to direct all traffic from the
# public subnet to the internet through the Internet Gateway
resource "aws_route" "perf-loadgen-route-public" {
  route_table_id         = aws_route_table.perf-loadgen-route-table-public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.gateway_id
}

# Private route config to direct all traffic from the private subnet
# to the internet through the NAT gateway
resource "aws_route" "perf-loadgen-route-private" {
  route_table_id         = aws_route_table.perf-loadgen-route-table-private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_id
}
