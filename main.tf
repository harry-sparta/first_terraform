# Main-tier main.tf

#---------------------------------Cloud----------------------------------------
# Configure a cloud provider
provider "aws" {
  region  = "eu-west-1"
}

#----------------------------------VPC-----------------------------------------
# Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block  = "10.0.0.0/16"
  tags  = {
    Name = "{$var.name} - VPC"
  }
}

# Creating an internet gateway
resource "aws_internet_gateway" "app_gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.name} - internet gateway"
  }
}

#---------------------------------Calling Modules-------------------------------
# Call module to create app_tier
module "app" {
  name = var.name
  source = "./modules/app_tier"
  vpc_id = aws_vpc.main_vpc.id
  gateway_id = aws_internet_gateway.app_gw.id
  app_ami_id = var.app_ami_id
}

# Call module to create db_tier
module "db" {
  name = var.name
  source = "./modules/db_tier"
  vpc_id = aws_vpc.main_vpc.id
  app_sg_id = module.app.app_sg_id
  db_ami_id = var.db_ami_id
}
