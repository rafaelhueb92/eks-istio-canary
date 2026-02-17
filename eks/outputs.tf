output "configure_kubectl_description" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = <<-EOF
      🎉 AKS Cluster created with success!

      👉 Run the following command to connect to your new EKS cluster:
      aws eks --region ${local.region} update-kubeconfig --name ${module.eks.cluster_name}
      
      EOF
}

output "kubectl_context" {
  description = "kubectl context"
  value       = "aws eks --region ${local.region} update-kubeconfig --name ${module.eks.cluster_name}"
}