# Db-tier main
#--------------------------------Subnets---------------------------------------
# Create a subnet
resource "aws_subnet" "db_subnet" {
  vpc_id  = var.vpc_id
  cidr_block  = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  tags  = {
    Name = "${var.name} - db subnet (private)"
  }
}

#--------------------------------NACL---------------------------------------
# Create a NACL for db_subnet (private)
resource "aws_network_acl" "db_subnet_nacl" {
  vpc_id = var.vpc_id
  subnet_ids = [aws_subnet.db_subnet.id]

  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 27017
    to_port    = 27017
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 102
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
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
    Name = "${var.name} - db NACL (private)"
  }
}

#-----------------------------Security Groups----------------------------------
resource "aws_security_group" "db_sg" {
  description = "Allow TLS inbound traffic"
  vpc_id  = var.vpc_id
  tags  = {
    Name = "${var.name} - db security group"
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
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    security_groups = [var.app_sg_id]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

#-------------------------------Instance---------------------------------------
# Launch an instance
resource "aws_instance" "db_instance" {
  ami = var.db_ami_id
  subnet_id = aws_subnet.db_subnet.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  instance_type  = "t2.micro"
  associate_public_ip_address = true
  tags  = {
    Name = "${var.name} - instance of db"
    }
}
