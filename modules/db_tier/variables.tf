# Place holder for vpc_id call module from main tier
variable "vpc_id" {
  description = "the vpc id interpolated from main tier"
}

# Place holder for mdo call module from main tier
variable "app_sg_id" {
  description = "interpolration of security group from app"
}

# Place holder for gateway_id call module from main tier
variable "db_ami_id" {
  description = "the db_ami_id interpolated from main tier"
}

# Place holder for the tag name variable
variable "name" {
  description = "name interpolated from original main-tier"
}
