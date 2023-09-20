provider "aws" {
  region     = "us-east-1"
#   access_key = "my-access-key"
#   secret_key = "my-secret-key"
}

resource "aws_instance" "demo-server" {
  ami = "ami-0f34c5ae932e6f0e4"
  instance_type = "t2.micro"
  key_name = "dpkey"
  #security_groups = [ "demo_sg" ]
  vpc_security_group_ids = [ aws_security_group.demo_sg.id ]
  subnet_id = aws_subnet.dpw-public_subnet_01.id
}
resource "aws_security_group" "demo_sg" {
  name        = "demo_sg"
  description = "Allow SSH traffic"
  vpc_id = aws_vpc.dpw-vpc.id

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

resource "aws_vpc" "dpw-vpc" {

    cidr_block = "10.1.0.0/16"
    tags = {
      Name = "dpw-vpc"
    }
}

resource "aws_subnet" "dpw-public_subnet_01" {
  vpc_id = aws_vpc.dpw-vpc.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"
  tags = {
    Name = "dpw-public_subnet_01"
  }
}

resource "aws_subnet" "dpw-public_subnet_02" {
  vpc_id = aws_vpc.dpw-vpc.id
  cidr_block = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1b"
  tags = {
    Name = "dpw-public_subnet_02"
  }
}

resource "aws_internet_gateway" "dpw-igw" {
  vpc_id = aws_vpc.dpw-vpc.id
  tags = {
    Name = "dpw-igw"
  }
}

resource "aws_route_table" "dpw-public-rt" {
    vpc_id = aws_vpc.dpw-vpc.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dpw-igw.id
    }
    tags = {
      Name = "dpw-public-rt"
    }
  
}

resource "aws_route_table_association" "dpw-rta-public-subnet-1" {
  subnet_id = aws_subnet.dpw-public_subnet_01.id
  route_table_id = aws_route_table.dpw-public-rt.id
}

resource "aws_route_table_association" "dpw-rta-public-subnet-2" {
  subnet_id = aws_subnet.dpw-public_subnet_02.id
  route_table_id = aws_route_table.dpw-public-rt.id
}