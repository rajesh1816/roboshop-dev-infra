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
  type    = list(number)
  default = [22, 6379]
}

variable "mysql_ports" {
  type    = list(number)
  default = [22, 3306]
}

variable "rabbitmq_ports" {
  type    = list(number)
  default = [22, 5672]
}

variable "databases_ports" {
  type    = list(number)
  default = [22, 27017, 6379, 3306, 5672]
}