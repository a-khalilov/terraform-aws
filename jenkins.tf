provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

resource "aws_instance" "jenkins" {
  ami                    = "ami-0b418580298265d5c"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.vlan1.id
  key_name               = "terraform_ec2_key"
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
  key_name   = "terraform_ec2_key"
  public_key = file("~/.ssh/id_rsa.pub")
}







