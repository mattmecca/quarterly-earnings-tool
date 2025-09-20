# Querying VPC for Cluster
# DATA BLOCK is used to query AWS ENVIRONMENT for info, and so you
# aren't actually making a resource, you are QUERYING something from 
# cloud environment
# Querying VPC for Cluster
data "aws_availability_zones" "azs" {}

# Using VPC from terraform-aws-modules so we don't have to create our own
# See: https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
# Resource will OUTPUT VPC ID, etc. based off of INPUTS we feed it in variables.tf (partially)
# Using VPC from terraform-aws-modules
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.name
  cidr = var.vpc_cidr_block

  azs             = data.aws_availability_zones.azs.names
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets  = var.public_subnet_cidr_blocks

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = var.tags
}

# EKS Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.2"
  
  # Defined in variables.tf
  cluster_name                   = var.name
  cluster_version                = var.k8s_version
  # Want to be able to access cluster PUBLICALLY  
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  create_cluster_security_group = false
  create_node_security_group    = false

  # Let the module handle KMS key creation and conflicts
  create_kms_key = false # true
  # kms_key_deletion_window_in_days = 7
  cluster_encryption_config = []

  # Person that creates cluster will also have ADMIN access
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }
  # Managed node group are the EC2s you want to attach to your 
  # cluster as WORKER NODES
  eks_managed_node_groups = {
    node-group-1 = {
      instance_types = ["t3.small"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1
    }
  }

  tags = var.tags
}

# The Elastic Container Registry (ECR) where we store our images
module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.3.0"

  repository_name                 = var.ecr_repository
  registry_scan_type              = "BASIC"
  repository_type                 = "private"
  create_lifecycle_policy         = false
  repository_image_tag_mutability = "MUTABLE"

  tags = {
    Terraform = "true"
  }
}