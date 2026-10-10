terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = "AWS-EKS-GitOps-Platform"
      ManagedBy   = "Terraform"
    }
  }
}

locals {
  cluster_name = "${var.project_name}-${var.environment}"
}

# -----------------------------------------------------------------------------
# 1. NETWORKING LAYER (VPC)
# -----------------------------------------------------------------------------
module "vpc" {
  source = "../../modules/vpc"

  cluster_name         = local.cluster_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  single_nat_gateway   = true # Cost-optimized for dev environment

  tags = {
    Environment = var.environment
  }
}

# -----------------------------------------------------------------------------
# 2. KUBERNETES LAYER (EKS)
# -----------------------------------------------------------------------------
module "eks" {
  source = "../../modules/eks"

  cluster_name           = local.cluster_name
  cluster_version        = var.cluster_version
  environment            = var.environment
  public_subnet_ids      = module.vpc.public_subnet_ids
  private_subnet_ids     = module.vpc.private_subnet_ids
  enable_public_endpoint = true
  instance_types         = var.instance_types
  capacity_type          = "ON_DEMAND"
  desired_nodes          = 2
  min_nodes              = 1
  max_nodes              = 4

  tags = {
    Environment = var.environment
  }

  depends_on = [module.vpc]
}
