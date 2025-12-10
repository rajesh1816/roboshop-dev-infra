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
  default = "Z05791913LISJO8IEXE2Y"
}

variable "zone_name" {
  default = "rajeshit.space"
}