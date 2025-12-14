module "component" {
  source         = "git::https://github.com/rajesh1816/terraform-components-module.git?ref=main"
  component      = var.component
  rule_priority  = var.rule_priority
  component_port = var.component_port
}