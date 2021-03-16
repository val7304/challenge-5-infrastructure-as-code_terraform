data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

provider "aws" {
  region = local.region
}

resource "random_id" "id" {
  byte_length = 2
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = format("%s-vpc-%s", local.prefix, random_id.id.hex)
  cidr                 = local.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  azs = local.azs

  public_subnets = [
    for num in range(length(local.azs)) :
    cidrsubnet(local.cidr, 8, num)
  ]

  tags = {
    Name        = format("%s-vpc-%s", local.prefix, random_id.id.hex)
    Terraform   = "true"
    Environment = "dev"
  }
}

module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = format("%s-web-server-%s", local.prefix, random_id.id.hex)
  description = "Security group for web-server with HTTP ports"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [local.cidr, local.allowed_app_cidr]
}

module "ssh_secure_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name        = format("%s-ssh-%s", local.prefix, random_id.id.hex)
  description = "Security group for SSH ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [local.cidr, local.allowed_mgmt_cidr]
}

module aws-nginx-demo {
  source  = "codygreen/nginx-demo-app/aws"
  version = "0.1.2"

  prefix = format(
    "%s-%s",
    local.prefix,
    random_id.id.hex
  )
  
  associate_public_ip_address = true
  ec2_key_name                = var.ec2_key_name
  vpc_security_group_ids = [
    module.web_server_sg.this_security_group_id,
    module.ssh_secure_sg.this_security_group_id
  ]
  vpc_subnet_ids     = module.vpc.public_subnets
  ec2_instance_count = 4
}

locals {
  prefix            = "tf-aws-nginx-demo-app"
  region            = "us-east-2"
  azs               = ["us-east-2a", "us-east-2b"]
  cidr              = "10.0.0.0/16"
  allowed_app_cidr  = "0.0.0.0/0"
  allowed_mgmt_cidr = "0.0.0.0/0"
}

resource "aws_key_pair" "admin" {
  key_name   = "admin"
  public_key =  file("ssh-keys/id_rsa_aws.pub") 
}

