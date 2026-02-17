################################################################################
# Istio Namespace
################################################################################

resource "kubernetes_namespace_v1" "istio_system" {
  metadata {
    name = "istio-system"
  }
  depends_on = [module.eks]
}



################################################################################
# Istio Base Chart
################################################################################

resource "helm_release" "istio_base" {
  name       = "istio-base"
  repository = local.istio_chart_url
  chart      = "base"
  version    = local.istio_chart_version
  namespace  = kubernetes_namespace_v1.istio_system.metadata[0].name

  timeout = 300

  depends_on = [module.eks]
}

################################################################################
# Istio Control Plane (istiod)
################################################################################

resource "helm_release" "istiod" {
  name       = "istiod"
  repository = local.istio_chart_url
  chart      = "istiod"
  version    = local.istio_chart_version
  namespace  = kubernetes_namespace_v1.istio_system.metadata[0].name

  timeout = 300
  wait    = true

  set {
    name  = "meshConfig.accessLogFile"
    value = "/dev/stdout"
  }

  depends_on = [helm_release.istio_base]
}

################################################################################
# Istio Ingress
################################################################################

resource "kubernetes_namespace_v1" "istio_ingress" {
  metadata {
    name = "istio-ingress"
  }
  depends_on = [module.eks]
}

resource "helm_release" "istio_ingressgateway" {
  name       = "istio-ingress"
  repository = local.istio_chart_url
  chart      = "gateway"
  namespace  = kubernetes_namespace_v1.istio_ingress.metadata[0].name

  wait    = false
  timeout = 600

  values = [
    <<-EOF
    service:
      type: LoadBalancer
      annotations:
        service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
    labels:
        app: istio-ingress
        istio: ingressgateway
    EOF
  ]
}
