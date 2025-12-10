/* resource "aws_key_pair" "vpn" {
  key_name = "openvpnkey"
  #public_key = file("C:\\keys\\openvpn.pub") in windows
  #public_key = file("C:\\keys\\openvpn.pub") # for linux
  public_key = file("D:\\Joindevops\\daws-84s\\openvpn.pub")
} */


resource "aws_instance" "openvpn" {
  ami                         = "ami-058fbc284998614e2"
  instance_type               = "t3.medium"
  subnet_id                   = local.public_subnet_ids
  vpc_security_group_ids      = [local.vpn_sg_id]
  associate_public_ip_address = true
  key_name                    = "openvpnkey" # make sure this key exist in AWS
  #key_name  = aws_key_pair.vpn.key_name
  user_data = file("openvpn.sh")
  tags = merge(
    var.openvpn_tags,
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-vpn"
    }
  )
}







