output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS Cluster API Server Endpoint"
  value       = module.eks.cluster_endpoint
}

output "oidc_provider_arn" {
  description = "IAM OIDC Provider ARN for IRSA"
  value       = module.eks.oidc_provider_arn
}

output "configure_kubectl_command" {
  description = "Command to configure local kubeconfig"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region}"
}
