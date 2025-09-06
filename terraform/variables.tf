variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "name" {
  default = "quarterly-earnings-tool-eks"
}

# Repository name in Elastic Container Repository (ECR)
variable "ecr_repo" {
  default = "quarterly-earnings-tool"
}

variable "k8s_version" {
  default = "1.31"
}

# VPC uses CIDR IP addresses when transfering data packets bw connected devices
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}
# Private subnet variables
variable "private_subnet_cidr_blocks" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
# Public subnet variables
variable "public_subnet_cidr_blocks" {
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "tags" {
  default = {
    App = "eks-cluster"
  }
}
