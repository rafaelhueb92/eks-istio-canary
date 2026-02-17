resource "null_resource" "observability_install" {
  triggers = {
    cluster_endpoint = module.eks.cluster_endpoint
    oidc_issuer      = module.eks.cluster_oidc_issuer_url
  }

  provisioner "local-exec" {
    command = <<-EOT
      
    for ADDON in kiali jaeger prometheus grafana
    do
        echo "📦 Installing $ADDON"
        ADDON_URL="https://raw.githubusercontent.com/istio/istio/release-1.20/samples/addons/$ADDON.yaml"
        kubectl apply --server-side -f $ADDON_URL
    done

    EOT
  }

  depends_on = [
    module.eks
  ]
}