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

