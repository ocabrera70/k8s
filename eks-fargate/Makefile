init::	
	@export TF_WORKSPACE=eks-fargate && terraform init
plan:: init		
	@export TF_WORKSPACE=eks-fargate && aws-vault exec mine -- terraform plan -var-file="config.tfvars"
apply:: init	
	@export TF_WORKSPACE=eks-fargate && aws-vault exec mine -- terraform apply -var-file="config.tfvars" -auto-approve
destroy:: init		
	@export TF_WORKSPACE=eks-fargate && aws-vault exec mine -- terraform destroy -var-file="config.tfvars" -auto-approve
kubeconfig::
	@export TF_WORKSPACE=my-workspace && export cluster_region=$$(aws-vault exec mine -- terraform output -raw region)  && \
	export cluster_name=$$(aws-vault exec mine -- terraform output -raw cluster_name) && \
	aws-vault exec mine -- aws eks update-kubeconfig --region "$${cluster_region}" \
	--name "$${cluster_name}"
acg-init::	
	@export TF_WORKSPACE=acg-eks-fargate && terraform init
acg-plan:: acg-init		
	@export TF_WORKSPACE=acg-eks-fargate && terraform plan -var-file="terraform.acg.tfvars"
acg-apply:: acg-init		
	@export TF_WORKSPACE=acg-eks-fargate && terraform apply -var-file="terraform.acg.tfvars" -auto-approve
acg-destroy:: acg-init		
	@export TF_WORKSPACE=acg-eks-fargate && terraform destroy -var-file="terraform.acg.tfvars" -auto-approve
acg-kubeconfig::
	@export TF_WORKSPACE=acg-eks-fargate && export cluster_region=$$(terraform output -raw region)  && \
	export cluster_name=$$(terraform output -raw cluster_name) && \
	aws eks update-kubeconfig --region "$${cluster_region}" \
	--name "$${cluster_name}"