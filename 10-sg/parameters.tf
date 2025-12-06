resource "aws_ssm_parameter" "sg_id" {
  name  = "/${var.project}/${var.environment}/sg-id"
  type  = "String"
  value = module.sg.sg_id
}