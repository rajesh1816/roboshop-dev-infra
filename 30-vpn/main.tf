resource "aws_key_pair" "vpn" {
    key_name   = "openvpn"
    #public_key = file("C:\\keys\\openvpn.pub") in windows
    public_key = file("/tmp/openvpn.pub") # for linux
}



resource "aws_instance" "openvpn" {
  ami           = data.aws_ami.openvpn.id
  instance_type = "t3.micro"

  subnet_id              = local.public_subnet_ids[0]
  vpc_security_group_ids = [local.vpn_sg_id]

  associate_public_ip_address = true
  user_data = file("openvpn.sh")

  tags = merge(
    var.openvpn_tags,
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-vpn"
    }
  )
}

resource "aws_marketplace_agreement" "openvpn" {
  product_code  = "8icvdraalzbfrdevgamoddblf"  # From the error
  accept        = true
}

resource "aws_instance" "openvpn" {
  depends_on = [aws_marketplace_agreement.openvpn]  # Ensure subscription is accepted first
  ami           = "ami-xxxxxxxxxxxxxxx"            # Your OpenVPN AMI ID
  instance_type = "t2.micro"
  # other parameters...
}



