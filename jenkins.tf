provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

resource "aws_instance" "jenkins" {
  ami           = "ami-0b418580298265d5c"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.vlan1.id
  key_name = "terraform_ec2_key"
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }
  provisioner "file" {
  source      = "jenkins.sh"
  destination = "/tmp/jenkins.sh"

  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/jenkins.sh",
      "/tmp/jenkins.sh",
    ]
  }


}


resource "aws_key_pair" "terraform_ec2_key" {
  key_name = "terraform_ec2_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

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


/*
resource "aws_network_interface" "lan1" {
  subnet_id   = aws_subnet.vlan1.id
  private_ips = ["192.168.0.10"]


  tags = {
    Name = "primary_network_interface"
  }
}
*/
resource "aws_security_group" "jenkins_sg" {
  name        = "Jenkins security group"
  vpc_id = aws_vpc.main_vpc.id
  description = "Allow HTTP and SSH inbound traffic"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
