# Outputs app security group id
output app_sg_id {
  description = "this is the id from my security group from app-tier"
  value = aws_security_group.app_sg.id
}
