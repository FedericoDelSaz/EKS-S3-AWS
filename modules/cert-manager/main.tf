resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = local.kubernetes_namespace
  }
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  namespace  = local.kubernetes_namespace
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = var.cert_manager_version
  wait       = var.wait

  set {
    name  = "image.tag"
    value = var.cert_manager_version
  }

  set {
    name  = "webhook.image.tag"
    value = var.cert_manager_version
  }

  set {
    name  = "cainjector.image.tag"
    value = var.cert_manager_version
  }

  set {
    name  = "installCRDs"
    value = true
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.cert_manager_sa.metadata[0].name
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_role_policy,
    kubernetes_service_account.cert_manager_sa
  ]
}

resource "aws_iam_policy" "cert_manager_access_to_route53" {
  name = "${var.eks_cluster_id}-cert-manager"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:GetChange"
            ],
            "Resource": [
                "arn:aws:route53:::change/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets",
                "route53:ListResourceRecordSets"
            ],
            "Resource": [
                "arn:aws:route53:::hostedzone/Z046184827U434VQ8IIR5"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role" "cert_manager" {
  name = "${var.eks_cluster_id}-cert-manager"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${var.aws_account_id}:oidc-provider/${var.eks_oidc_issuer_url}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${var.eks_oidc_issuer_url}:sub": "system:serviceaccount:cert-manager:cert-manager"
        }
      }
    }
  ]
}
EOF
}


# Allows eks cert-manager to assume the role inside the network account in order to get Route 53 entries
resource "aws_iam_role_policy_attachment" "eks_role_policy" {
  role       = aws_iam_role.cert_manager.name
  policy_arn = "arn:aws:iam::aws:policy/AWSNetworkManagerFullAccess"

  depends_on = [aws_iam_role.cert_manager]
}

# Kubernetes service account for cert-manager controller
resource "kubernetes_service_account" "cert_manager_sa" {
  metadata {
    name        = local.service_account_name
    namespace   = local.kubernetes_namespace
    annotations = { "eks.amazonaws.com/role-arn" : aws_iam_role.cert_manager.arn }
  }
  automount_service_account_token = true
}
