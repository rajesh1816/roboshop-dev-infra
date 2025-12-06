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
