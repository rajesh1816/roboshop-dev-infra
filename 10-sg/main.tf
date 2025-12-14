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
resource "aws_security_group_rule" "bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}

# bastion host outbound rule
resource "aws_security_group_rule" "bastion_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # all protocols
  cidr_blocks       = ["0.0.0.0/0"] # allow to anywhere
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

# Allowing backend alb from bastion
resource "aws_security_group_rule" "backend_alb_allow_http_from_bastion" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_allow_http_from_frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id
  security_group_id = module.backend_alb.sg_id
}

# allowing backend alb from vpn
resource "aws_security_group_rule" "backend_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.backend_alb.sg_id
}

# backend-alb host outbound rule
resource "aws_security_group_rule" "backend_alb_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # all protocols
  cidr_blocks       = ["0.0.0.0/0"] # allow to anywhere
  security_group_id = module.backend_alb.sg_id
}


#security group for frontend alb
module "frontend_alb" {
  source         = "git::https://github.com/rajesh1816/terraform-sg-module.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "frontend-alb"
  sg_description = "for frontend-alb"
  vpc_id         = local.vpc_id
}

# allowing http to frontend_alb from internet
resource "aws_security_group_rule" "frontend_alb_allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.frontend_alb.sg_id
}

# allowing https to frontend_alb from internet
resource "aws_security_group_rule" "frontend_alb_allow_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.frontend_alb.sg_id
}

# backend-alb host outbound rule
resource "aws_security_group_rule" "frontend_alb_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # all protocols
  cidr_blocks       = ["0.0.0.0/0"] # allow to anywhere
  security_group_id = module.frontend_alb.sg_id
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

# vpn host outbound rule
resource "aws_security_group_rule" "vpn_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # all protocols
  cidr_blocks       = ["0.0.0.0/0"] # allow to anywhere
  security_group_id = module.vpn.sg_id
}


# security for all databases
module "databases" {
  source         = "git::https://github.com/rajesh1816/terraform-sg-module.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "databases-sg"
  sg_description = "for databases"
  vpc_id         = local.vpc_id
}

# allowing connection from vpn host to databases host
resource "aws_security_group_rule" "databases_vpn" {
  count                    = length(var.databases_ports)
  type                     = "ingress"
  from_port                = var.databases_ports[count.index]
  to_port                  = var.databases_ports[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.databases.sg_id
}

# allowing connection from bastion host to databases host
resource "aws_security_group_rule" "databases_bastion" {
  count                    = length(var.databases_ports)
  type                     = "ingress"
  from_port                = var.databases_ports[count.index]
  to_port                  = var.databases_ports[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.databases.sg_id
}

# databases host outbound rule
resource "aws_security_group_rule" "databases_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # all protocols
  cidr_blocks       = ["0.0.0.0/0"] # allow to anywhere
  security_group_id = module.databases.sg_id
}

# security for catalogue
module "catalogue" {
  source         = "git::https://github.com/rajesh1816/terraform-sg-module.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "catalogue-sg"
  sg_description = "for catalogue"
  vpc_id         = local.vpc_id
}


/* # allowing catalogue to mongodb
resource "aws_security_group_rule" "mongodb_catalogue" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.catalogue.sg_id
  security_group_id = module.mongodb.sg_id
} */

# allowing catalogue to mongodb
resource "aws_security_group_rule" "mongodb_allow_catalogue" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.catalogue.sg_id
  security_group_id = module.databases.sg_id
}

#Catalogue vpn ssh 
resource "aws_security_group_rule" "catalogue_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.catalogue.sg_id
}

# catalogue bastion ssh
resource "aws_security_group_rule" "catalogue_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.catalogue.sg_id
}


# to access in browser catalogue service
resource "aws_security_group_rule" "catalogue_vpn_http" {
  type              = "ingress"
  from_port         = 8081
  to_port           = 8081
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.catalogue.sg_id
}

# to access in bastion catalogue service
resource "aws_security_group_rule" "catalogue_bastion_http" {
  type              = "ingress"
  from_port         = 8081
  to_port           = 8081
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.catalogue.sg_id
}

# allowing backend_alb to catalogue
resource "aws_security_group_rule" "catalogue_backend_alb" {
  type              = "ingress"
  from_port         = 8081
  to_port           = 8081
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id = module.catalogue.sg_id
}

# catalogue host outbound rule
resource "aws_security_group_rule" "catalogue_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # all protocols
  cidr_blocks       = ["0.0.0.0/0"] # allow to anywhere
  security_group_id = module.catalogue.sg_id
}

# security for user
module "user" {
  source         = "git::https://github.com/rajesh1816/terraform-sg-module.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "user-sg"
  sg_description = "for user"
  vpc_id         = local.vpc_id
}

# allowing mongodb component to user
resource "aws_security_group_rule" "mongodb_allow_user" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.user.sg_id
  security_group_id = module.mongodb.sg_id
}

# allowing redis component to user
resource "aws_security_group_rule" "redis_allow_user" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.user.sg_id
  security_group_id = module.redis.sg_id
}

# allowing user to bastion ssh
resource "aws_security_group_rule" "user_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.user.sg_id
}

# to access in bastion user service
resource "aws_security_group_rule" "user_bastion_http" {
  type              = "ingress"
  from_port         = 8082
  to_port           = 8082
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.user.sg_id
}

# to access user component from backend alb 
resource "aws_security_group_rule" "user_allow_http_backend_alb" {
  type              = "ingress"
  from_port         = 8082
  to_port           = 8082
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id = module.user.sg_id
}


# security for cart
module "cart" {
  source         = "git::https://github.com/rajesh1816/terraform-sg-module.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "cart-sg"
  sg_description = "for cart"
  vpc_id         = local.vpc_id
}

# allowing redis component to user
resource "aws_security_group_rule" "redis_allow_cart" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.cart.sg_id
  security_group_id = module.redis.sg_id
}

# allowing catalogue component to cart
resource "aws_security_group_rule" "catalogue_allow_cart" {
  type              = "ingress"
  from_port         = 8081
  to_port           = 8081
  protocol          = "tcp"
  source_security_group_id = module.cart.sg_id
  security_group_id = module.catalogue.sg_id
}

# allowing cart to bastion ssh
resource "aws_security_group_rule" "cart_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.cart.sg_id
}

# to access in bastion cart service
resource "aws_security_group_rule" "cart_allow_http_from_bastion" {
  type              = "ingress"
  from_port         = 8084
  to_port           = 8084
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.cart.sg_id
}

# to access cart component from backend alb 
resource "aws_security_group_rule" "cart_allow_http_from_backend_alb" {
  type              = "ingress"
  from_port         = 8084
  to_port           = 8084
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id = module.cart.sg_id
}




# security for shipping
module "shipping" {
  source         = "git::https://github.com/rajesh1816/terraform-sg-module.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "shipping-sg"
  sg_description = "for shipping"
  vpc_id         = local.vpc_id
}

# allowing shipping component to mysql
resource "aws_security_group_rule" "mysql_allow_shipping" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.shipping.sg_id
  security_group_id = module.mysql.sg_id
}

# allowing shipping component to cart 
resource "aws_security_group_rule" "cart_allow_shipping" {
  type              = "ingress"
  from_port         = 8084
  to_port           = 8084
  protocol          = "tcp"
  source_security_group_id = module.cart.sg_id
  security_group_id = module.shipping.sg_id
}

# allowing shipping to bastion ssh
resource "aws_security_group_rule" "shipping_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.shipping.sg_id
}

# to access in bastion shipping service
resource "aws_security_group_rule" "shipping_allow_http_from_bastion" {
  type              = "ingress"
  from_port         = 8083
  to_port           = 8083
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.shipping.sg_id
}

# to access shipping component from backend alb 
resource "aws_security_group_rule" "shipping_allow_http_from_backend_alb" {
  type              = "ingress"
  from_port         = 8083
  to_port           = 8083
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id = module.shipping.sg_id
}


# security group for payment
module "payment" {
  source         = "git::https://github.com/rajesh1816/terraform-sg-module.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "payment-sg"
  sg_description = "for payment"
  vpc_id         = local.vpc_id
}

# allowing payment component to cart
resource "aws_security_group_rule" "cart_allow_payment" {
  type              = "ingress"
  from_port         = 8084
  to_port           = 8084
  protocol          = "tcp"
  source_security_group_id = module.payment.sg_id
  security_group_id = module.cart.sg_id
}

# allowing payment component to user 
resource "aws_security_group_rule" "user_allow_payment" {
  type              = "ingress"
  from_port         = 8082
  to_port           = 8082
  protocol          = "tcp"
  source_security_group_id = module.payment.sg_id
  security_group_id = module.user.sg_id
}

# allowing payment to bastion ssh
resource "aws_security_group_rule" "payment_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.payment.sg_id
}

# to access in bastion payment service
resource "aws_security_group_rule" "payment_allow_http_from_bastion" {
  type              = "ingress"
  from_port         = 8085
  to_port           = 8085
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.payment.sg_id
}

# to access payment component from backend alb 
resource "aws_security_group_rule" "payment_allow_http_from_backend_alb" {
  type              = "ingress"
  from_port         = 8085
  to_port           = 8085
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id = module.payment.sg_id
}


# security group for frontend
module "frontend" {
  source         = "git::https://github.com/rajesh1816/terraform-sg-module.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "frontend-sg"
  sg_description = "for frontend"
  vpc_id         = local.vpc_id
}


# allowing frontend to bastion ssh
resource "aws_security_group_rule" "frontend_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.frontend.sg_id
}


# allowing frontend_alb to frontend
resource "aws_security_group_rule" "frontend_allow_frontend_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend_alb.sg_id
  security_group_id = module.frontend.sg_id
}


























/* #security group for mongodb
module "mongodb" {
  source         = "git::https://github.com/rajesh1816/terraform-sg-module.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "mongodb-sg"
  sg_description = "for mongodb"
  vpc_id         = local.vpc_id
}

# allowing connection from vpn host to mongodb
resource "aws_security_group_rule" "mongodb_vpn" {
  count = length(var.mongodb_ports)

  type                     = "ingress"
  from_port                = var.mongodb_ports[count.index]
  to_port                  = var.mongodb_ports[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.mongodb.sg_id
}

# allowing connection from bastion host to mongodb
resource "aws_security_group_rule" "mongodb_bastion" {
  count                    = length(var.mongodb_ports)
  type                     = "ingress"
  from_port                = var.mongodb_ports[count.index]
  to_port                  = var.mongodb_ports[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.mongodb.sg_id
}

# mongodb host outbound rule
resource "aws_security_group_rule" "mongodb_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # all protocols
  cidr_blocks       = ["0.0.0.0/0"] # allow to anywhere
  security_group_id = module.mongodb.sg_id
} */


/* #security group for redis
module "redis" {
  source         = "git::https://github.com/rajesh1816/terraform-sg-module.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "redis-sg"
  sg_description = "for redis"
  vpc_id         = local.vpc_id
}

# allowing connection from vpn host to redis
resource "aws_security_group_rule" "redis_vpn" {
  count = length(var.redis_ports)

  type                     = "ingress"
  from_port                = var.redis_ports[count.index]
  to_port                  = var.redis_ports[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.redis.sg_id
}

# allowing connection from bastion host to redis
resource "aws_security_group_rule" "redis_bastion" {
  count                    = length(var.redis_ports)
  type                     = "ingress"
  from_port                = var.redis_ports[count.index]
  to_port                  = var.redis_ports[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.redis.sg_id
}

# redis host outbound rule
resource "aws_security_group_rule" "redis_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # all protocols
  cidr_blocks       = ["0.0.0.0/0"] # allow to anywhere
  security_group_id = module.redis.sg_id
} */


/* #security group for rabbitmq
module "rabbitmq" {
  source         = "git::https://github.com/rajesh1816/terraform-sg-module.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "rabbitmq-sg"
  sg_description = "for rabbitmq"
  vpc_id         = local.vpc_id
}

# allowing connection from vpn host to rabbitmq
resource "aws_security_group_rule" "rabbitmq_vpn" {
  count = length(var.rabbitmq_ports)

  type                     = "ingress"
  from_port                = var.rabbitmq_ports[count.index]
  to_port                  = var.rabbitmq_ports[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.rabbitmq.sg_id
}

# allowing connection from bastion host to rabbitmq
resource "aws_security_group_rule" "rabbitmq_bastion" {
  count                    = length(var.rabbitmq_ports)
  type                     = "ingress"
  from_port                = var.rabbitmq_ports[count.index]
  to_port                  = var.rabbitmq_ports[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.rabbitmq.sg_id
}

# rabbitmq host outbound rule
resource "aws_security_group_rule" "rabbitmq_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # all protocols
  cidr_blocks       = ["0.0.0.0/0"] # allow to anywhere
  security_group_id = module.rabbitmq.sg_id
} */

/* #security group for mysql
module "mysql" {
  source         = "git::https://github.com/rajesh1816/terraform-sg-module.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "mysql-sg"
  sg_description = "for mysql"
  vpc_id         = local.vpc_id
}

# allowing connection from vpn host to mysql
resource "aws_security_group_rule" "mysql_vpn" {
  count = length(var.mysql_ports)

  type                     = "ingress"
  from_port                = var.mysql_ports[count.index]
  to_port                  = var.mysql_ports[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.mysql.sg_id
}

# allowing connection from bastion host to mysql
resource "aws_security_group_rule" "mysql_bastion" {
  count                    = length(var.mysql_ports)
  type                     = "ingress"
  from_port                = var.mysql_ports[count.index]
  to_port                  = var.mysql_ports[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.mysql.sg_id
}

# mysql host outbound rule
resource "aws_security_group_rule" "mysql_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # all protocols
  cidr_blocks       = ["0.0.0.0/0"] # allow to anywhere
  security_group_id = module.mysql.sg_id
} */







