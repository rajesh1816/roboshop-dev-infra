variable "component" {
  type    = string
  default = "frontend"
}

variable "rule_priority" {
  type    = number
  default = 10
}

variable "component_port" {
  type    = number
  default = 80
}