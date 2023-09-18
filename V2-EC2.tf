provider "aws" {
  region     = "us-east-1"
#   access_key = "my-access-key"
#   secret_key = "my-secret-key"
}

resource "aws_instance" "demo-server" {
  ami = "ami-0f34c5ae932e6f0e4"
  instance_type = "t2.micro"
  key_name = "dpkey"
  security_groups = [ "demo_sg" ]
}
resource "aws_security_group" "demo_sg" {
  name        = "demo_sg"
  description = "Allow SSH traffic"
#   vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-prot"
  }
}
