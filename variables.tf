# Setting variables via command lines
  # terraform apply -var="<name_of_variable=value"
  # terraform apply -var='<name_of_variable_list=["value_1","value_2"]'
  # terraform apply -var-file="variables.tf"

# Setting variables
  # Name tags
variable "name" {
  type = string
  default = "eng48-harry-li-terraform"
}

  # App AMI
variable "app_ami_id" {
  type = string
  default = "ami-0d8e5cfe85e85b81b"
}

# Db AMI
variable "db_ami_id" {
  type = string
  default = "ami-0c1c20912b942fb91"
}
