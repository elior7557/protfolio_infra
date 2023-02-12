module "cluster" {
  source        = "./modules/cluster"
  project_id    = var.project_id
  region        = var.region
  cluster_az    = var.cluster_az
  gke_num_nodes = var.gke_num_nodes
  machine_type  = var.machine_type
}

# Setup cluster with argocd
resource "helm_release" "argo" {
  name = "argo"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.19.0"
  namespace        = "argo"
  create_namespace = true

  depends_on = [
    module.cluster
  ]

  values = [
    "${file("helm/values.yaml")}"
  ]
}