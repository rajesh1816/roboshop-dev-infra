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
  default = "Z00035852NN6D25PW7BUM"
}

variable "zone_name" {
  default = "rajeshit.space"
}