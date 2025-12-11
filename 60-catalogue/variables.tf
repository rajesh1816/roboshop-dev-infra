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
  default = "Z01448731VZNPW3ACOZ36"
}

variable "zone_name" {
  default = "rajeshit.space"
}
