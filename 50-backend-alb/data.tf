data "aws_ssm_parameter" "vpc_id" {
  name            = "/${var.project}/${var.environment}/vpc-id"
  with_decryption = true # Set to true for SecureString parameters
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name            = "/${var.project}/${var.environment}/private-subnet-ids"
  with_decryption = true # Set to true for SecureString parameters
}

data "aws_ssm_parameter" "backend_alb_sg_id" {
  name            = "/${var.project}/${var.environment}/backend-alb-sg-id"
  with_decryption = true # Set to true for SecureString parameters
}