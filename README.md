# Terraform module for eks cluster autoscaler

This module deploys the following helm chart on an EKS cluster:

| Name               | Repository                              | Version |
| ------------------ | --------------------------------------- | ------- |
| cluster-autoscaler | https://kubernetes.github.io/autoscaler | 9.20.1  |

## Module input parameters

| Parameter              | Type     | Description                                                                                   |
| ---------------------- | -------- | --------------------------------------------------------------------------------------------- |
| namespace              | Required | The kubernetes namespace at which the EKS autoscaler chart will be deployed                   |
| eks_cluster_properties | Required | A map variable containing properties of the EKS cluster                                       |
| cluster_autoscaler_sa  | Optional | The name of the service account to be created for the EKS cluster autoscaler                  |
| node_selector          | Optional | A map variable with nodeSelector labels applied when placing pods of the chart on the cluster |

The structure of the "eks_cluster_properties" variable is as follows:

```
eks_cluster_properties = {
  eks_cluster_name            = <The name of the EKS cluster>
  openid_connect_provider_url = <URL of OpenID connect provider of EKS cluster>
  openid_connect_provider_arn = <ARN of OpenID connect provider of EKS cluster>  
}
```