#security group for bastion host
module "bastion" {
  source         = "git::https://github.com/rajesh1816/terraform-sg-module.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = var.bastion_sg_name
  sg_description = var.bastion_sg_description
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
}

#ingress rule for bastion sg
resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}


#security group for backend alb
module "backend_alb" {
  source         = "git::https://github.com/rajesh1816/terraform-sg-module.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = var.backend_alb_sg_name
  sg_description = var.backend_alb_description
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
}

#ingress rule for backend alb
resource "aws_security_group_rule" "bastion_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id  = module.bastion.sg_id
  security_group_id = module.backend_alb.sg_id
}



