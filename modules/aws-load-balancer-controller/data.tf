data "aws_iam_policy_document" "aws_load_balancer_controller_assume_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${var.eks_oidc_issuer_url}:sub"
      values   = ["system:serviceaccount:kube-system:${local.service_account_name}"]
    }

    principals {
      identifiers = [var.eks_oidc_provider_arn]
      type        = "Federated"
    }
  }
}