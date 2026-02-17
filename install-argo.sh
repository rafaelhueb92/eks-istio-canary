echo "📦 Installing ArgoCD"
kubectl create ns argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    
echo $(kubectl -n argocd get secret argocd-initial-admin-secret \
 -o jsonpath="{.data.password}" | base64 -d && echo) > argo_psw

echo "👉 If you wanna access the argocd Portal:\n
         - Run kubectl port-forward svc/argocd-server -n argocd 8080:443\n \
         - Setuser admin and the password in the argo_psw file"
    
echo "🔑 To log in argocd cli:\n \
      - Run the port-foward\n \
      - Run argocd login localhost:8080 --username admin --password $(cat argo_psw | xargs) --insecure"