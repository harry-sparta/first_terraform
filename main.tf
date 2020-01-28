
# Configure a cloud provider
provider "aws" {
  region  = "eu-west-1"
}


# Create a VPC
resource "aws_vpc" "app_vpc" {
  cidr_block  = "10.0.0.0/16"
  tags  = {
    Name = var.name
  }
}


# Create a subnet
resource "aws_subnet" "app_subnet" {
  vpc_id  = aws_vpc.app_vpc.id
  cidr_block  = "10.0.0.0/24"
  availability_zone = "eu-west-1a"
  tags  = {
    Name = var.name
  }
}


# Create security group
resource "aws_security_group" "app_security_group" {
  description = "Allow TLS inbound traffic"
  vpc_id  = aws_vpc.app_vpc.id
  tags  = {
    Name = var.name
    }

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 2
    to_port     = 22
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

# Creating an internet gateway
resource "aws_internet_gateway" "app_gw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.name} - internet gateway"
  }
}

# Creating a route table
resource "aws_route_table" "app_route" {
  vpc_id  = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_gw.id
  }

  tags = {
    Name = "${var.name} - route"
  }
}

# Set route table associations
resource "aws_route_table_association" "app_route_assoc" {
  subnet_id = aws_subnet.app_subnet.id
  route_table_id = aws_route_table.app_route.id
}

# Launch an instance
resource "aws_instance" "app_instance" {
  ami  = var.ami_python
  subnet_id = aws_subnet.app_subnet.id
  vpc_security_group_ids = [aws_security_group.app_security_group.id]
  instance_type  = "t2.micro"
  associate_public_ip_address = true
  user_data = data.template_file.app_init.rendered     # Telling the instance to be aware of data may be coming from the specificed template file
  tags  = {
    Name = "${var.name} - instance of app"
    }
}

# Send template shell file
data "template_file" "app_init" {
  template = "${file("./scripts/init_script.sh.tpl")}"
}
