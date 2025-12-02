module "sg" {
  source         = "../../terraform-sg-module"
  project        = var.project
  environment    = var.environment
  sg_name        = var.sg_name
  sg_description = var.sg_description
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
}