resource "aws_vpc" "main" {
  cidr_block       = "192.168.0.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "Demo-vpc"
    Environment = "stage"
  }
}
resource "aws_subnet" "pub-sub1" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "192.168.0.0/26"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "Pub-sub1"
    Environment = "stage"
  }
}
resource "aws_subnet" "pri-sub1" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "192.168.0.64/26"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Pri-sub1"
    Environment = "stage"
  }
}
resource "aws_subnet" "pub-sub2" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "192.168.0.128/26"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Pub-sub2"
    Environment = "stage"
  }
}
resource "aws_subnet" "pri-sub2" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "192.168.0.192/26"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "Pri-sub2"
    Environment = "stage"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "Demo-IGW"
    Environment = "stage"
  }
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  tags = {
    Name = "public-route"
    Environment = "stage"
  }
}

resource "aws_route_table_association" "pub-route-associate1" {
  subnet_id      = aws_subnet.pub-sub1.id
  route_table_id = aws_route_table.r.id
}
resource "aws_route_table_association" "pub-route-associate2" {
  subnet_id      = aws_subnet.pub-sub2.id
  route_table_id = aws_route_table.r.id
}
resource "aws_eip" "ip" {
  vpc      = true
}

resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.ip.id}"
  subnet_id     = "${aws_subnet.pub-sub1.id}"

  tags = {
    Name = "Demo-NAT"
    Environment = "stage"
  }
}
resource "aws_route_table" "r2" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.gw.id}"
  }
  tags = {
    Name = "private-route"
    Environment = "stage"
  }
}
resource "aws_route_table_association" "pri-route-associate1" {
  subnet_id      = aws_subnet.pri-sub1.id
  route_table_id = aws_route_table.r2.id
}
resource "aws_route_table_association" "pri-route-associate2" {
  subnet_id      = aws_subnet.pri-sub2.id
  route_table_id = aws_route_table.r2.id
}
