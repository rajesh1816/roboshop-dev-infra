data "aws_ssm_parameter" "public_subnets" {
  name = "/${var.project}/${var.environment}/public-subnet-ids"
}

locals {
  public_subnets = split(",", data.aws_ssm_parameter.public_subnets.value)
}

data "aws_ami" "joindevops" {
  most_recent = true
  owners      = ["973714476881"]

  filter {
    name   = "name"
    values = ["RHEL-9-DevOps-Practice"]
  }
}

data "aws_ssm_parameter" "bastion_sg_id" {
  name = "/${var.project}/${var.environment}/bastion-sg-id"
}


