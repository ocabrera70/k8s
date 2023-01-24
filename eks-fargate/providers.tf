terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }

  cloud {
    organization = "ocabrera70"
  }
}

provider "aws" {
  region  = var.region  
}

locals {
  helm_args = concat(["eks", "get-token", "--cluster-name", aws_eks_cluster.eks_cluster.name])
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority.0.data)
    exec {
      api_version = var.helm_exec_api_version
      args        = local.helm_args
      command     = "aws"
    }
  }
}