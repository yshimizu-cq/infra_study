resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.app_name}-vpc-${var.environment}"
  }
}

resource "aws_subnet" "public_1a" {
  # 作成したVPCを参照し、そのVPC内にSubnetを立てる
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-northeast-1a"
  # 10.0.0.0は大規模IPアドレス
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "${var.app_name}-subnet-public-1a-${var.environment}"
  }
}

resource "aws_subnet" "public_1c" {
  # 作成したVPCを参照し、そのVPC内にSubnetを立てる
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-northeast-1c"
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = "${var.app_name}-subnet-public-1c-${var.environment}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-internet-gateway-${var.environment}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-route-table-${var.environment}"
  }
}

resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public.id
}
