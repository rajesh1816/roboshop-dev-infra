module "backend_alb" {
  source = "terraform-aws-modules/alb/aws"
  internal = true

  name    = "${var.project}-${var.environment}-backend-alb"
  vpc_id  = local.vpc_id
  subnets = local.private_subnet_ids
  security_groups = [local.backend_alb_sg_id]
  create_security_group = false
  enable_deletion_protection = false

  tags = merge(
    var.backend_alb_tags,
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-backend-alb"
    }
  )

}