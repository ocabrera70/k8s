resource "aws_eks_fargate_profile" "fargate_profile_dev" {
  cluster_name           = aws_eks_cluster.eks_cluster.name
  fargate_profile_name   = "development"
  pod_execution_role_arn = aws_iam_role.eks_pod_execution_role.arn
  subnet_ids             = module.vpc.private_subnets

  selector {
    namespace = "development"
  }

  selector {
    namespace = "qa"
  }

  selector {
    namespace = "kube-system"
  }  
}

resource "null_resource" "core-dns" {
  triggers = {    
    name=aws_eks_fargate_profile.fargate_profile_dev.fargate_profile_name
  }
  provisioner "local-exec" {
    on_failure  = fail
    when        = create
    interpreter = ["/bin/bash", "-c"]
    working_dir = path.module
    command     = <<EOT
      aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.eks_cluster.name}
      kubectl patch deployment coredns \
      -n kube-system \
      --type json \
      -p='[{"op": "remove", "path": "/spec/template/metadata/annotations/eks.amazonaws.com~1compute-type"}]'
      kubectl rollout restart -n kube-system deployment coredns
EOT
  }
}