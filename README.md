# EKS Istio Canary Deployment

<div align="center">

![Project art](./images/title.jpeg)

</div>

A complete Terraform and Kubernetes setup for deploying ArgoCD, Istio service mesh, and observability stack on AWS EKS with canary deployment patterns.

## 📋 Prerequisites

- AWS account with appropriate permissions
- Terraform >= 1.0
- kubectl >= 1.27
- AWS CLI configured
- Git

## 🚀 Quick Start

### 1. Clone and Navigate to the Project

```bash
cd eks-istio-canary
```

### 2. Initialize Terraform

```bash
cd eks
terraform init
```

### 3. Deploy the Infrastructure

```bash
terraform plan
terraform apply
```

This will create:

- VPC with public and private subnets across 3 AZs
- EKS cluster with optimized t3.medium instances
- ECR repository
- Istio service mesh
- ArgoCD for GitOps
- Observability stack (Prometheus, Grafana, Jaeger)

### 4. Configure kubectl

```bash
aws eks update-kubeconfig --name istio-eks-project --region us-west-2
```

### 5. Deploy Application with ArgoCD

```bash
./install-argo.sh
```

Then access ArgoCD UI:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Get initial password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

## 📁 Project Structure

```
.
├── eks/                          # Terraform infrastructure
│   ├── cluster.tf               # EKS cluster configuration
│   ├── vpc.tf                   # VPC and networking
│   ├── ecr.tf                   # ECR repository
│   ├── istio.tf                 # Istio deployment
│   ├── observability.tf         # Monitoring stack
│   ├── variables.tf             # Variable definitions
│   └── ...
├── manifests/                    # Kubernetes manifests
│   ├── namespace.yaml           # Namespace setup
│   ├── deploy-v1.yaml           # App version 1
│   ├── deploy-v2.yaml           # App version 2 (canary)
│   ├── virtualservice.yaml      # Istio traffic routing
│   ├── destinationrule.yaml     # Istio destination rules
│   ├── gateway.yaml             # Istio gateway
│   └── service.yaml             # Kubernetes service
├── app/                          # Application code
│   ├── dockerfile               # Docker image definition
│   └── nodejs/                  # Node.js application
├── argo-app.yaml                # ArgoCD application
└── init.sh                       # Initialization script
```

## 🔧 Configuration

### Instance Types

The cluster uses **t3.medium** instances for cost efficiency:

- 2 vCPU
- 4 GB RAM
- Suitable for ArgoCD, Istio, and observability stack
- Min: 1 node, Max: 3 nodes

To modify instance configuration, edit `eks/cluster.tf`:

```terraform
eks_managed_node_groups = {
  initial = {
    instance_types = ["t3.medium"]
    min_size     = 1
    max_size     = 3
    desired_size = 1
  }
}
```

### Environment Variables

Create `.env` or update these variables in `eks/variables.tf`:

```hcl
variable "git_username" {
  default = "your-github-username"
}

variable "ecr_repo_name" {
  default = "your-app-name"
}
```

## 🎯 Canary Deployments

This repository includes manifests for canary deployments:

1. **Virtual Service** - Routes traffic between v1 and v2
2. **Destination Rules** - Defines traffic policies
3. **Two Deployments** - v1 (stable) and v2 (canary)

Adjust traffic distribution in `manifests/virtualservice.yaml`:

```yaml
http:
  - match:
      - sourceLabels:
          version: v1
    route:
      - destination:
          host: myapp
          subset: v1
        weight: 90
      - destination:
          host: myapp
          subset: v2
        weight: 10
```

## 📊 Observability

Access monitoring dashboards:

### Prometheus

```bash
kubectl port-forward -n observability svc/prometheus 9090:9090
```

### Grafana

```bash
kubectl port-forward -n observability svc/grafana 3000:3000
```

### Jaeger

```bash
kubectl port-forward -n observability svc/jaeger 16686:16686
```

## 🗑️ Cleanup

To destroy all resources:

```bash
cd eks
terraform destroy
```

## 📚 Additional Resources

- [Istio Documentation](https://istio.io/latest/docs/)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [AWS EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)

## 📝 License

This project is open source and available under the MIT License.

## 👤 Author

Rafael Hueb - [GitHub](https://github.com/rafaelhueb)
