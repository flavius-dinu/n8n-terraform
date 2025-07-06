variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type        = string
  description = "SSH key pair name"
}

variable "public_key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "my_ip_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "domain_name" {
  type        = string
  description = "Root domain name (e.g. mydomain.com)"
}

variable "create_dns_record" {
  default = true
}

variable "basic_auth_user" {
  type    = string
  default = "admin"
}

variable "basic_auth_password" {
  type = string
}

variable "n8n_encryption_key" {
  type = string
}

variable "n8n_user_management_jwt_secret" {
  type = string
}
