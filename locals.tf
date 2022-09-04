locals {
  eks_cluster_name            = var.eks_cluster_properties["eks_cluster_name"]
  openid_connect_provider_url = replace(var.eks_cluster_properties["openid_connect_provider_url"], "https://", "")
  openid_connect_provider_arn = var.eks_cluster_properties["openid_connect_provider_arn"]
}