data "aws_region" "current" {}

resource "aws_iam_role" "eks_cluster_autoscaler_role" {
  name = "eks_cluster_autoscaler_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "${local.openid_connect_provider_arn}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "${local.openid_connect_provider_url}:sub" : "system:serviceaccount:${var.namespace}:${var.cluster_autoscaler_sa}"
          }
        }
      }
    ]
  })

  managed_policy_arns = [aws_iam_policy.eks_cluster_autoscaler_policy.arn]
}

resource "aws_iam_policy" "eks_cluster_autoscaler_policy" {
  name = "eks_cluster_autoscaler_policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeLaunchTemplateVersions"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      }
    ]
  })
}

resource "helm_release" "cluster-autoscaler" {
  chart            = "cluster-autoscaler"
  name             = "cluster-autoscaler"
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://kubernetes.github.io/autoscaler"
  version          = "9.20.1"
  wait             = true

  values = [
    templatefile("${path.module}/templates/cluster-autoscaler.yaml", {
      eks_cluster_name           = local.eks_cluster_name
      aws_region                 = data.aws_region.current.name
      autoscaler_service_account = var.cluster_autoscaler_sa
      node_selector              = var.node_selector
      eks_autoscaler_role_arn    = aws_iam_role.eks_cluster_autoscaler_role.arn
    })
  ]

  depends_on = [aws_iam_role.eks_cluster_autoscaler_role]
}