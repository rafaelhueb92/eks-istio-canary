variable  "git_username" {
  description = "Git username for ArgoCD"
  type        = string
  default     = "rafaelhueb92"
}

variable "ecr_repo_name" {
  type        = string
  description = "ECR repository name"
  default     = "nextjs-canary"
}