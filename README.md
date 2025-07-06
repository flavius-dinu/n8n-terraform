# n8n Terraform Infrastructure

This repository contains Terraform configuration to deploy a self-hosted n8n instance on AWS. 
The infrastructure automatically provisions an EC2 instance, configures security groups, optionally sets up DNS records, and deploys n8n using Docker Compose with the AI starter kit.

## 🚀 Features

- **Automated AWS Infrastructure**: Complete Terraform configuration for n8n deployment
- **Self-Hosted n8n with AI**: Uses the official n8n AI starter kit for enhanced AI capabilities
- **Security Configuration**: Properly configured security groups with restricted SSH access
- **DNS Integration**: Optional Route53 DNS record creation
- **Docker-based Deployment**: Automated container deployment with environment configuration
- **Sample Workflow**: Includes a JSON tutorial workflow for learning n8n basics

## 📋 Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (>= 1.0)
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- An AWS account with permissions to create EC2 instances, security groups, and Route53 records
- An SSH key pair for EC2 instance access
- A domain name (optional, for DNS configuration)

## 🏗️ Infrastructure Components

### AWS Resources Created

- **EC2 Instance**: Ubuntu 20.04 LTS instance running n8n
- **Security Group**: Configured with ports 22 (SSH), 80 (HTTP), 443 (HTTPS), and 5678 (n8n)
- **SSH Key Pair**: For secure instance access
- **Route53 DNS Record**: Optional A record pointing to the n8n instance
- **EBS Volume**: 15GB root volume for the instance

### Application Stack

- **n8n**: Latest version with AI capabilities
- **PostgreSQL**: Database for n8n data persistence
- **Docker & Docker Compose**: Container orchestration
- **Environment Configuration**: Secure environment variables management

## ⚙️ Configuration

### Required Variables

Create a `terraform.tfvars` file with the following variables:

```hcl
# AWS Configuration
aws_region = "eu-west-1"
instance_type = "t2.micro"

# SSH Configuration
key_name = "your-key-name"
public_key_path = "~/.ssh/id_rsa.pub"
my_ip_cidr = "your-ip/32"  # Restrict SSH access to your IP

# Domain Configuration
domain_name = "yourdomain.com"
create_dns_record = true

# n8n Security
basic_auth_user = "admin"
basic_auth_password = "your-secure-password"
n8n_encryption_key = "your-32-character-encryption-key"
n8n_user_management_jwt_secret = "your-jwt-secret"
```

### Variable Descriptions

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region for deployment | `eu-west-1` |
| `instance_type` | EC2 instance type | `t2.micro` |
| `key_name` | SSH key pair name | Required |
| `public_key_path` | Path to public SSH key | `~/.ssh/id_rsa.pub` |
| `my_ip_cidr` | Your IP address for SSH access | `0.0.0.0/0` |
| `domain_name` | Root domain for DNS records | Required |
| `create_dns_record` | Whether to create Route53 DNS record | `true` |
| `basic_auth_user` | n8n admin username | `admin` |
| `basic_auth_password` | n8n admin password | Required |
| `n8n_encryption_key` | n8n encryption key (32 chars) | Required |
| `n8n_user_management_jwt_secret` | JWT secret for user management | Required |

## 🚀 Deployment

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Review the Plan

```bash
terraform plan
```

### 3. Apply the Configuration

```bash
terraform apply
```

### 4. Access n8n

After successful deployment, you can access n8n at:

- **Direct IP**: `http://<instance-public-ip>:5678`
- **Domain** (if DNS configured): `http://n8n.yourdomain.com:5678`

### 5. Login

Use the credentials specified in your `terraform.tfvars`:
- Username: `admin` (or your custom `basic_auth_user`)
- Password: Your `basic_auth_password`

## 📁 Project Structure

```
n8n-terraform/
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Variable definitions
├── outputs.tf              # Output values
├── terraform.tfvars        # Variable values (create this)
├── .gitignore              # Git ignore rules
├── .terraform.lock.hcl     # Terraform dependency lock
├── n8n-json-workflow.json  # Sample n8n workflow
└── templates/
    ├── env.tmpl            # Environment variables template
    └── user_data.sh.tmpl   # EC2 user data script
```

## 🔧 Customization

### Instance Type

Modify the `instance_type` variable in `terraform.tfvars` to change the EC2 instance size:

```hcl
instance_type = "t3.medium"  # For better performance
```

### Security Groups

Edit the security group rules in `main.tf` to modify network access:

```hcl
# Example: Restrict n8n access to specific IPs
ingress {
  from_port   = 5678
  to_port     = 5678
  protocol    = "tcp"
  cidr_blocks = ["your-ip/32"]
}
```

### Environment Variables

Modify `templates/env.tmpl` to add additional n8n environment variables.

## 📊 Outputs

After deployment, Terraform will output:

- `n8n_instance_public_ip`: The public IP address of the n8n instance
- `n8n_dns_record`: The DNS record URL (if DNS is configured)

## 🔒 Security Considerations

- **SSH Access**: Configure `my_ip_cidr` to restrict SSH access to your IP
- **Passwords**: Use strong, unique passwords for all authentication
- **Encryption Keys**: Generate secure 32-character encryption keys
- **HTTPS**: Consider setting up SSL/TLS certificates for production use
- **Firewall**: The security group allows HTTP/HTTPS access from anywhere; restrict as needed

## 🧹 Cleanup

To destroy the infrastructure:

```bash
terraform destroy
```

⚠️ **Warning**: This will permanently delete all created resources and data.

## 📚 Included Workflow

The repository includes `n8n-json-workflow.json`, a tutorial workflow that teaches JSON basics. Import this workflow into your n8n instance to learn about:

- JSON data types (strings, numbers, booleans, arrays, objects)
- Key-value pairs
- Data structure concepts

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the deployment
5. Submit a pull request


## 🔗 Resources

- [n8n Documentation](https://docs.n8n.io/)
- [n8n AI Starter Kit](https://github.com/n8n-io/self-hosted-ai-starter-kit)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)