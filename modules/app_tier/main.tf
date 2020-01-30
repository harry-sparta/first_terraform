# App_tier main.tf
# place all that concerns the app tier in here

#--------------------------------Subnets---------------------------------------
# Create a subnet
resource "aws_subnet" "app_subnet" {
  vpc_id  = var.vpc_id
  cidr_block  = "10.0.0.0/24"
  availability_zone = "eu-west-1a"
  tags  = {
    Name = "${var.name} - app subnet (public)"
  }
}

#--------------------------------NACL---------------------------------------
# Create a NACL for app_subnet (public)
resource "aws_network_acl" "app_subnet_nacl" {
  vpc_id = var.vpc_id
  subnet_ids = [aws_subnet.app_subnet.id]

  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 102
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 103
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1000
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 201
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "${var.name} - app NACL (public)"
  }
}

#-----------------------------Security Groups----------------------------------
# Create security group
resource "aws_security_group" "app_sg" {
  description = "Allow TLS inbound traffic"
  vpc_id  = var.vpc_id
  tags  = {
    Name = var.name
    }

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 1000
    to_port     = 65535
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

#----------------------------Route Table---------------------------------------
# Creating a route table
resource "aws_route_table" "app_route" {
  vpc_id  = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.gateway_id
  }

  tags = {
    Name = "${var.name} - route table (public)"
  }
}

# Set route table associations
resource "aws_route_table_association" "app_route_assoc" {
  subnet_id = aws_subnet.app_subnet.id
  route_table_id = aws_route_table.app_route.id
}

#-------------------------------Instance---------------------------------------
# Launch an instance
resource "aws_instance" "app_instance" {
  ami  = var.app_ami_id
  subnet_id = aws_subnet.app_subnet.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  instance_type  = "t2.micro"
  associate_public_ip_address = true
  user_data = data.template_file.app_init.rendered     # Telling the instance to be aware of data may be coming from the specificed template file
  tags  = {
    Name = "${var.name} - instance of app"
    }
}

#--------------------------------Template--------------------------------------
# Send template shell file
data "template_file" "app_init" {
  template = "${file("./scripts/init_script.sh.tpl")}"
}
