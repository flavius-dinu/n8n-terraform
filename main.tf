provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "n8n_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "n8n_sg" {
  name = "n8n-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5678
    to_port     = 5678
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

locals {
  env_rendered = templatefile("${path.module}/templates/env.tmpl", {
    POSTGRES_USER                  = var.basic_auth_user
    POSTGRES_PASSWORD              = var.basic_auth_password
    N8N_ENCRYPTION_KEY             = var.n8n_encryption_key
    N8N_USER_MANAGEMENT_JWT_SECRET = var.n8n_user_management_jwt_secret
  })

  user_data_rendered = templatefile("${path.module}/templates/user_data.sh.tmpl", {
    env_file = replace(local.env_rendered, "$", "\\$")
  })
}

resource "aws_instance" "n8n" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.n8n_key.key_name
  vpc_security_group_ids = [aws_security_group.n8n_sg.id]

  root_block_device {
    volume_size           = 15
    delete_on_termination = true
  }

  user_data = local.user_data_rendered
  tags = {
    Name = "n8n-server"
  }
}

data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "n8n_dns" {
  count   = var.create_dns_record ? 1 : 0
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "n8n.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.n8n.public_ip]
}
