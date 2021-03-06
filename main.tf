data "aws_ami" "rhel_ami" {
  most_recent = true
  owners      = ["309956199498"]

  filter {
    name   = "name"
    values = ["*RHEL-7.3_HVM_GA-*"]
  }
}

resource "random_id" "name" {
  byte_length = 4
}

resource "aws_key_pair" "awskey" {
  key_name   = "awskwy-${random_id.name.hex}"
  public_key = tls_private_key.awskey.public_key_openssh
}

resource "aws_instance" "ubuntu" {
  count                   = var.instance_count
  ami                     = data.aws_ami.rhel_ami.id
  instance_type           = var.instance_type
  key_name                = aws_key_pair.awskey.key_name
  vpc_security_group_ids  = var.vpc_security_group_ids
  subnet_id               = var.subnet_id

  tags = {
    Name        = var.name
    TTL         = var.ttl
    Owner       = var.owner
    Description = "This branch updated v6"
  }
}
