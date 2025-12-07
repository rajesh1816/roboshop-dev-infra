variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "bastion_sg_name" {
  default = "roboshop-bastion-sg"
}

variable "bastion_sg_description" {
  default = "security group for roboshop frontend service"
}

variable "vpn_ports" {
  type    = list(number)
  default = [22, 443, 1194, 943]
}

variable "mongodb_ports" {
  type    = list(number)
  default = [22, 27017]
}

variable "redis_ports" {
  default = [22, 6379]
}

variable "mysql_ports" {
  default = [22, 3306]
}

variable "rabbitmq_ports" {
  default = [22, 5672]
}