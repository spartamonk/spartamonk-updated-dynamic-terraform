# AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_subnet
  tags = {
    Name = "${terraform.workspace}-vpc"
  }
}

# Subnets
resource "aws_subnet" "subnets" {
  for_each                = var.subnets
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  cidr_block              = cidrsubnet(var.vpc_subnet, 8, index(keys(var.subnets), each.key))
  availability_zone       = data.aws_availability_zones.available.names[each.value.availability_zone]
  tags = {
    Name = each.key
  }
}


# IGW
locals {
  has_public_subnet = anytrue(flatten([for _, subnet in var.subnets : subnet[*].map_public_ip_on_launch]))
  public_subnet_id  = try([for _, subnet in aws_subnet.subnets : subnet.id if subnet.map_public_ip_on_launch][0], null)
  private_subnet_id = try([for _, subnet in aws_subnet.subnets : subnet.id if subnet.map_public_ip_on_launch][0], null)
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  count  = local.has_public_subnet ? 1 : 0
  tags = {
    Name = "igw"
  }
}

# Route table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id
  count  = local.has_public_subnet ? 1 : 0
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw[0].id
  }

  tags = {
    Name = "internet_rt"
  }
}


resource "aws_route_table_association" "a" {
  count          = local.has_public_subnet ? 1 : 0
  subnet_id      = local.public_subnet_id
  route_table_id = aws_route_table.rt[0].id
}