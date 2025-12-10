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

data "aws_ssm_parameter" "catalogue_sg_id" {
  name            = "/${var.project}/${var.environment}/catalogue-sg-id"
  with_decryption = true # Set to true for SecureString parameters
}

data "aws_ami" "joindevops" {
  owners           = ["973714476881"]
  most_recent      = true

  filter {
    name   = "name"
    values = ["RHEL-9-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ssm_parameter" "backend_alb_listener_arn" {
  name            = "/${var.project}/${var.environment}/backend-alb-listener-arn"
  with_decryption = true # Set to true for SecureString parameters
}