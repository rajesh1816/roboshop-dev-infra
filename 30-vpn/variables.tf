variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "openvpn_tags" {
  type = map(string)
  default = {
  }
}