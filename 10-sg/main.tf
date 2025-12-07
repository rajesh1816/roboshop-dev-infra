#security group for bastion host
module "bastion" {
  source         = "git::https://github.com/rajesh1816/terraform-sg-module.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = var.bastion_sg_name
  sg_description = var.bastion_sg_description
  vpc_id         = local.vpc_id
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
  sg_name        = "backend-alb"
  sg_description = "for backend-alb"
  vpc_id         = local.vpc_id
}

#ingress rule for backend alb
resource "aws_security_group_rule" "backend_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id  = module.bastion.sg_id
  security_group_id = module.backend_alb.sg_id
}


#security group for vpn
module "vpn" {
  source         = "git::https://github.com/rajesh1816/terraform-sg-module.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "roboshop-vpn"
  sg_description = "for vpn"
  vpc_id         = local.vpc_id
}


# Create ingress rules for each port in the vpn_ports list
resource "aws_security_group_rule" "vpn_ingress_rules" {
  count = length(var.vpn_ports)

  type              = "ingress"
  from_port         = var.vpn_ports[count.index]
  to_port           = var.vpn_ports[count.index]
  protocol          = "tcp" 
  cidr_blocks       = ["0.0.0.0/0"] 
  security_group_id = module.vpn.sg_id
}



