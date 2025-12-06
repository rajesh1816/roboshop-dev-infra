module "sg" {
  source         = "git::https://github.com/rajesh1816/terraform-sg-module.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = var.sg_name
  sg_description = var.sg_description
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
}