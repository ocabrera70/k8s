resource "aws_eks_cluster" "eks_cluster" {
  name     = local.cluster_name
  role_arn = aws_iam_role.eks_master_role.arn

  vpc_config {
    subnet_ids = module.vpc.public_subnets
  }

  version = var.eks_version  

  depends_on = [
    aws_iam_role.eks_master_role
  ]
}