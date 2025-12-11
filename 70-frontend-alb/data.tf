data "aws_ssm_parameter" "vpc_id" {
  name            = "/${var.project}/${var.environment}/vpc-id"
  with_decryption = true # Set to true for SecureString parameters
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name            = "/${var.project}/${var.environment}/public-subnet-ids"
  with_decryption = true # Set to true for SecureString parameters
}

data "aws_ssm_parameter" "frontend_alb_sg_id" {
  name            = "/${var.project}/${var.environment}/frontend-alb-sg-id"
  with_decryption = true # Set to true for SecureString parameters
}