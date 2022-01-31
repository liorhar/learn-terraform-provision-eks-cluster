terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 1.1.0"
}


provider "aws" {
  region  = var.region
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "${var.env_prefix}-eks-"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name                 = "${var.env_prefix}-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway   = true
  enable_vpn_gateway = true

  single_nat_gateway   = false
  one_nat_gateway_per_az = true
  enable_dns_hostnames = true

tags = {
    Terraform = "true"
    Environment = var.env_prefix
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
