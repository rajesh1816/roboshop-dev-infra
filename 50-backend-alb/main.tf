module "backend_alb" {
  source   = "terraform-aws-modules/alb/aws"
  internal = true

  name                       = "${var.project}-${var.environment}-backend-alb"
  vpc_id                     = local.vpc_id
  subnets                    = local.private_subnet_ids
  security_groups            = [local.backend_alb_sg_id]
  create_security_group      = false
  enable_deletion_protection = false
  version                    = "9.16.0"

  tags = merge(
    var.backend_alb_tags,
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-backend-alb"
    }
  )

}


resource "aws_lb_listener" "backend_alb" {
  load_balancer_arn = module.backend_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/html"
      message_body = "Hello, I am from ALB"
      status_code  = "200"
    }
  }
}


