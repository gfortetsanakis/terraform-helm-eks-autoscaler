variable "namespace" {
  description = "The kubernetes namespace at which the EKS autoscaler chart will be deployed."
}

variable "eks_cluster_properties" {
  description = "A map variable containing properties of the EKS cluster."
}

variable "cluster_autoscaler_sa" {
  description = "The name of the service account to be created for the EKS cluster autoscaler."
  default     = "cluster-autoscaler-sa"
}

variable "node_selector" {
  description = "A map variable with nodeSelector labels applied when placing pods of the chart on the cluster."
  default     = {}
}