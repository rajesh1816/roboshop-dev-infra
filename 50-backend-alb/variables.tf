variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "backend_alb_tags" {
  type = map(string)
  default = {
  }
}


variable "zone_id" {
  default = "Z071935815H0BEQ3N2QXO"
}

variable "zone_name" {
  default = "rajeshit.space"
}