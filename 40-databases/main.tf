# mongodb instance
resource "aws_instance" "mongodb" {
  ami           = local.ami_id
  instance_type = "t3.micro"

  subnet_id              = local.private_subnet_ids[0]
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

  depends_on = [aws_instance.mongodb.id]
  triggers_replace = [aws_instance.mongodb.id]


  #  Copy script to EC2
  provisioner "file" {
    source      = "bootstrap.sh" # Path to the local file
    destination = "/tmp/bootstrap.sh" # Destination path on the EC2 instance
  }

  
  connection {
    type        = "ssh"
    host        = aws_instance.mongodb.private_ip
    user        = "ec2-user"
    password    = "DevOps321" 
  
  }

  #  RUN script on EC2
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mongodb"
    ]
  }
}





# redis instance
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

  depends_on = [aws_instance.redis.id]
  triggers_replace = [aws_instance.redis.id]


  #  Copy script to EC2
  provisioner "file" {
    source      = "bootstrap.sh" # Path to the local file
    destination = "/tmp/bootstrap.sh" # Destination path on the EC2 instance
  }

  
  connection {
    type        = "ssh"
    host        = aws_instance.redis.private_ip
    user        = "ec2-user"
    password    = "DevOps321" 
  
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

  depends_on = [aws_instance.rabbitmq.id]
  triggers_replace = [aws_instance.rabbitmq.id]


  #  Copy script to EC2
  provisioner "file" {
    source      = "bootstrap.sh" # Path to the local file
    destination = "/tmp/bootstrap.sh" # Destination path on the EC2 instance
  }

  
  connection {
    type        = "ssh"
    host        = aws_instance.rabbitmq.private_ip
    user        = "ec2-user"
    password    = "DevOps321" 
  
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


  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-mysql"
    }
  )
}


# mysql configuration
resource "terraform_data" "mysql" {

  depends_on = [aws_instance.mysql.id]
  triggers_replace = [aws_instance.mysql.id]


  #  Copy script to EC2
  provisioner "file" {
    source      = "bootstrap.sh" # Path to the local file
    destination = "/tmp/bootstrap.sh" # Destination path on the EC2 instance
  }

  
  connection {
    type        = "ssh"
    host        = aws_instance.mysql.private_ip
    user        = "ec2-user"
    password    = "DevOps321" 
  
  }

  #  RUN script on EC2
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mysql"
    ]
  }
}


