# VPC
resource "aws_vpc" "main3" {
  cidr_block = "10.0.0.0/16"
}

# Subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main3.id
  cidr_block = "10.0.1.0/24"
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main3.id
}

# Route Table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main3.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# Associate Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rt.id
}

# Security Group
resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main3.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "strapi"{
    ami="ami-00a929b66ed6e0de6"
    instance_type          = var.instance_type
    subnet_id                   = aws_subnet.main.id
    vpc_security_group_ids      = [aws_security_group.allow_ssh_http.id]
    key_name      = var.key_name
    associate_public_ip_address = true

    # Reference your user data shell script
  user_data = file("${path.module}/user_data.sh")

 tags = {
    Name = "Strapi-EC2"
  }


}
