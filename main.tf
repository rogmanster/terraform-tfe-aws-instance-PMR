
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "random_id" "name" {
  byte_length = 4
}

resource "aws_instance" "ubuntu" {
  count                   = var.instance_count
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = var.instance_type
  key_name                = var.key_name
  vpc_security_group_ids  = var.security_group_id
  subnet_id               = var.subnet_id
  #key_name                = data.aws_key_pair.example.key_name
  #vpc_security_group_ids  = [data.terraform_remote_state.aws_security_group.outputs.security_group_id]
  #subnet_id               = data.terraform_remote_state.aws_vpc_prod.outputs.public_subnets[0]

  tags = {
    name        = var.name
    ttl         = var.ttl
    env         = var.env
    description = var.description
  }

  //requires Terraform v1.2 or higher
  //https://developer.hashicorp.com/terraform/language/expressions/custom-conditions#self-object
  lifecycle {
    postcondition {
      condition     = self.instance_state == "running"
      error_message = "EC2 instance must be running."
    }
  }
}
