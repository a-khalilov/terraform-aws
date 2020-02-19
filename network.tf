resource "aws_vpc" "main_vpc" {   
cidr_block       = "192.168.0.0/16"   
tags = {     
Name = "Main VPC"   } 
}

resource "aws_subnet" "vlan1" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "192.168.0.0/24"
  availability_zone = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Vlan 1"
  }
}
