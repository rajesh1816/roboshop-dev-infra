module "frontend_alb" {
  source   = "terraform-aws-modules/alb/aws"
  internal = false

  name                       = "${var.project}-${var.environment}-backend-alb"
  vpc_id                     = local.vpc_id
  subnets                    = local.public_subnet_ids
  security_groups            = [local.frontend_alb_sg_id]
  create_security_group      = false
  enable_deletion_protection = false
  version                    = "9.16.0"

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-frontend-alb"
    }
  )

}


resource "aws_lb_listener" "frontend_alb" {
  load_balancer_arn = module.frontend_alb.arn
  port              = 80 # 443
  protocol          = "HTTP" #HTTPS
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = local.acm_certificate_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/html"
      message_body = "Hello, I am from ALB"
      status_code  = "200"
    }
  }
}


# route 53 record for backend-ALB
resource "aws_route53_record" "frontend_alb" {
  zone_id = var.zone_id
  name    = "${var.environment}.${var.zone_name}" #dev.rajeshit.site
  type    = "A"

  alias {
    name                   = module.frontend_alb.dns_name
    zone_id                = module.frontend_alb.zone_id # This is the ZONE ID of ALB
    evaluate_target_health = true
  }
}


