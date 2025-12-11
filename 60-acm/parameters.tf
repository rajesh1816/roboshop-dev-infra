resource "aws_ssm_parameter" "acm_certificate_arn" {
  name  = "/${var.project}/${var.environment}/acm-certificate-arn"
  type  = "String"
  value = aws_acm_certificate.daws84s.arn
}