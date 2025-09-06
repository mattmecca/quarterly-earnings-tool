terraform {
  required_version = "~> 1.0"
  backend "s3" { # SPECIFYING BUCKETS USED
    bucket = "quarterly-earnings-tool" # bucket = "infrabucket-iacgitops-eu-west-2"
    key    = "iac-actions/state.tfstate"
    region = "us-east-2"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.3"
    }
    helm = { # REFERENCES HELM CHART
      source  = "hashicorp/helm"
      version = "~> 2.16"
    }
  }
}