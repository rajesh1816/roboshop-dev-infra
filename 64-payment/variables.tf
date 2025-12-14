variable "component" {
  type    = string
  default = "payment"
}

variable "rule_priority" {
  type    = number
  default = 50
}

variable "component_port" {
  type    = number
  default = 8085
}