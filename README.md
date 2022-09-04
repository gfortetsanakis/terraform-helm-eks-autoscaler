# Terraform module for eks cluster autoscaler

This module deploys the EKS cluster autoscaler chart.

## Module input parameters

| Parameter              | Type     | Description                                                                           |
| ---------------------- |--------- | ------------------------------------------------------------------------------------- |
| namespace              | Required | The kubernetes namespace at which the EKS autoscaler chart will be deployed           |
| eks_cluster_properties | Required | A map variable containing properties of the EKS cluster                               |
| cluster_autoscaler_sa  | Optional | The name of the service account to be created for the EKS cluster autoscaler              |
| node_selector          | Optional | A map variable with nodeSelector labels applied when placing pods of the chart on the cluster |