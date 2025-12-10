resource "aws_instance" "databases" {
  ami                    = local.ami_id
  instance_type          = "t2.medium"
  subnet_id              = local.database_subnet_ids
  vpc_security_group_ids = [local.databases_sg_id]
  #iam_instance_profile = "EC2toFetchParams"
  iam_instance_profile = "EC2toFetchParams-comp"
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-databases"
    }
  )
}

# mongodb configuration
resource "terraform_data" "databases" {
  triggers_replace = [aws_instance.databases.id]
  #  Copy script to EC2
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }
  connection {
    type     = "ssh"
    host     = aws_instance.databases.private_ip
    user     = "ec2-user"
    password = "DevOps321"
  }
  #  RUN script on EC2
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mongodb ${var.environment}",
      "sudo sh /tmp/bootstrap.sh mysql ${var.environment}",
      "sudo sh /tmp/bootstrap.sh redis ${var.environment}",
      "sudo sh /tmp/bootstrap.sh rabbitmq ${var.environment}"
    ]
  }
} 


#record for mongodb
resource "aws_route53_record" "mongodb_r53" {
  zone_id = var.zone_id
  name    = "mongodb-${var.environment}.${var.zone_name}" #mongodb-dev.rajeshit.space
  type    = "A"
  ttl     = 1
  records = [aws_instance.databases.private_ip]
  allow_overwrite = true
}

#record for redis
resource "aws_route53_record" "redis_r53" {
  zone_id = var.zone_id
  name    = "redis-${var.environment}.${var.zone_name}" #redis-dev.rajeshit.space
  type    = "A"
  ttl     = 1
  records = [aws_instance.databases.private_ip]
  allow_overwrite = true
}

#record for rabbitmq
resource "aws_route53_record" "rabbitmq_r53" {
  zone_id = var.zone_id
  name    = "rabbitmq-${var.environment}.${var.zone_name}" #rabbitmq-dev.rajeshit.space
  type    = "A"
  ttl     = 1
  records = [aws_instance.databases.private_ip]
  allow_overwrite = true
}

#record for mysql
resource "aws_route53_record" "mysql_r53" {
  zone_id = var.zone_id
  name    = "mysql-${var.environment}.${var.zone_name}" #mysql-dev.rajeshit.space
  type    = "A"
  ttl     = 1
  records = [aws_instance.databases.private_ip]
  allow_overwrite = true
}



















/* # mongodb instance
resource "aws_instance" "mongodb" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id              = local.database_subnet_ids
  vpc_security_group_ids = [local.mongodb_sg_id]
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-mongodb"
    }
  )
}

# mongodb configuration
resource "terraform_data" "mongodb" {

  triggers_replace = [aws_instance.mongodb.id]
  #  Copy script to EC2
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }
  connection {
    type     = "ssh"
    host     = aws_instance.mongodb.private_ip
    user     = "ec2-user"
    password = "DevOps321"
  }
  #  RUN script on EC2
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mongodb {{ var.environment }}"
    ]
  }
} */








#iam_instance_profile = "EC2toFetchParams"
/* # redis instance
resource "aws_instance" "redis" {
  ami           = local.ami_id
  instance_type = "t3.micro"

  subnet_id              = local.private_subnet_ids[0]
  vpc_security_group_ids = [local.redis_sg_id]


  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-redis"
    }
  )
}


# redis configuration
resource "terraform_data" "redis" {
  triggers_replace = [aws_instance.redis.id]


  #  Copy script to EC2
  provisioner "file" {
    source      = "bootstrap.sh"      # Path to the local file
    destination = "/tmp/bootstrap.sh" # Destination path on the EC2 instance
  }
  connection {
    type     = "ssh"
    host     = aws_instance.redis.private_ip
    user     = "ec2-user"
    password = "DevOps321"

  }

  #  RUN script on EC2
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh redis"
    ]
  }
}


# rabbitmq instance
resource "aws_instance" "rabbitmq" {
  ami           = local.ami_id
  instance_type = "t3.micro"

  subnet_id              = local.private_subnet_ids[0]
  vpc_security_group_ids = [local.rabbitmq_sg_id]


  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-rabbitmq"
    }
  )
}


# rabbitmq configuration
resource "terraform_data" "rabbitmq" {

  depends_on       = [aws_instance.rabbitmq]
  triggers_replace = [aws_instance.rabbitmq.id]


  #  Copy script to EC2
  provisioner "file" {
    source      = "bootstrap.sh"      # Path to the local file
    destination = "/tmp/bootstrap.sh" # Destination path on the EC2 instance
  }


  connection {
    type     = "ssh"
    host     = aws_instance.rabbitmq.private_ip
    user     = "ec2-user"
    password = "DevOps321"

  }

  #  RUN script on EC2
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh rabbitmq"
    ]
  }
}


# mysql instance
resource "aws_instance" "mysql" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id              = local.private_subnet_ids[0]
  vpc_security_group_ids = [local.mysql_sg_id]
  iam_instance_profile = "EC2toFetchParams"


  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-mysql"
    }
  )
}


# mysql configuration
resource "terraform_data" "mysql" {

  depends_on       = [aws_instance.mysql]
  triggers_replace = [aws_instance.mysql.id]


  #  Copy script to EC2
  provisioner "file" {
    source      = "bootstrap.sh"      # Path to the local file
    destination = "/tmp/bootstrap.sh" # Destination path on the EC2 instance
  }


  connection {
    type     = "ssh"
    host     = aws_instance.mysql.private_ip
    user     = "ec2-user"
    password = "DevOps321"

  }

  #  RUN script on EC2
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mysql"
    ]
  }
} */


