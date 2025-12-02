resource "aws_instance" "jump_host" {
  ami           = data.aws_ami.joindevops.id
  instance_type = var.instance_type

  subnet_id              = local.public_subnets[0]
  vpc_security_group_ids = [data.aws_ssm_parameter.sg_id.value]

  associate_public_ip_address = true

  tags = merge(
    var.jump_host_tags,
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-jump-host"
    }
  )
}


output "subnet_value" {
  value     = local.public_subnets[0]
  sensitive = true
}