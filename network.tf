resource "aws_vpc" "main" {

  cidr_block = "10.0.0.0/16"

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-vpc" })
  )
}

resource "aws_internet_gateway" "main" {

  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-igw" })
  )
}

resource "aws_subnet" "ec2_subnet" {

  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_region.current.name}a"


  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-ec2" })
  )
}

resource "aws_route_table" "ec2_rt" {

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-ec2-rt" })
  )
}

resource "aws_route_table_association" "ec2_rt_association" {

  subnet_id      = aws_subnet.ec2_subnet.id
  route_table_id = aws_route_table.ec2_rt.id
}