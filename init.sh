set -euo pipefail

echo "🚀 Initializing Terraform"
cd eks
terraform init
terraform apply -refresh-only
terraform apply -auto-approve 

echo "☸️ Configuring kubectl"

$(terraform output kubectl_context | xargs)

echo "✅ Initialization complete"

ISTIO_INGRESS_URL=$(kubectl get svc istio-ingress -n istio-ingress -o jsonpath='{.status.loadBalancer.ingress[*].hostname}')

echo "🪱 applying the agocd application manifest"

kubectl apply -f argo-app.yaml

echo "👉 To access the app, visit: http://${ISTIO_INGRESS_URL}"

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

echo "🔐 Logging into ECR"

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com

echo "🚢 Building and pushing the canary app image"

cd ../app

docker build -t nextjs-canary .

docker tag nextjs-canary:latest $ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/nextjs-canary:latest

echo "📤 Pushing the image to ECR"

docker push $ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/nextjs-canary:latest