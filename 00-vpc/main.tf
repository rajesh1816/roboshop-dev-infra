module "vpc" {
  source              = "git::https://github.com/rajesh1816/terraform-aws-vpc-module.git?ref=main"
  vpc_cidr_block      = var.vpc_cidr_block
  project             = var.project
  environment         = var.environment
  public_cidr_block   = var.public_cidr_block
  private_cidr_block  = var.private_cidr_block
  database_cidr_block = var.database_cidr_block
  is_peering_required = true
}

