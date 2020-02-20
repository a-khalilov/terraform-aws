resource "aws_internet_gateway" "main_gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "Main GW"
  }
}

resource "aws_route_table" "to_inet" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gw.id
  }
  tags = {
    Name = "Main Route"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.vlan1.id
  route_table_id = aws_route_table.to_inet.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.vlan2.id
  route_table_id = aws_route_table.to_inet.id
}