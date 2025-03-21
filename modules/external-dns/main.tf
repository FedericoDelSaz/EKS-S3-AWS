resource "helm_release" "external_dns" {
  name       = "external-dns"
  namespace  = kubernetes_service_account.aws_external_dns_sa.metadata[0].namespace
  wait       = true
  repository = "https://kubernetes-sigs.github.io/external-dns"
  chart      = "external-dns"
  version    = "1.14.4"

  set {
    name  = "rbac.create"
    value = false
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.aws_external_dns_sa.metadata[0].name
  }

  set {
    name  = "policy"
    value = "upsert-only"
  }

  set {
    name  = "registry"
    value = "txt"
  }

  set {
    name  = "logLevel"
    value = var.external_dns_chart_log_level
  }

  set {
    name  = "sources"
    value = var.external_dns_source_discovery
  }

  set {
    name  = "domainFilters[0]"
    value = "xsp.corpinter.net"
  }

  set {
    name  = "txtOwnerId"
    value = "Z00890442CFWMEJTO4S3M"
  }

  set {
    name  = "provider"
    value = "aws"
  }

  set {
    name  = "extraArgs[0]"
    value = "--aws-assume-role=arn:aws:iam::${var.aws_network_account_id}:role/${var.eks_cluster_id}-xsp-external-dns-cross-account"
  }


  depends_on = [
    aws_iam_role_policy_attachment.eks_role_policy,
    aws_iam_role_policy_attachment.attach_route53_update_policy_to_cross_account_role,
    kubernetes_cluster_role_binding.external_dns
  ]
}

resource "aws_iam_policy" "allow_external_dns_route53_updates" {
  name     = "${var.eks_cluster_id}-allow-external-dns-updates"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets"
            ],
            "Resource": [
                "arn:aws:route53:::hostedzone/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "route53:ListHostedZones",
                "route53:ListResourceRecordSets"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role" "allow_external_dns_to_assume_role" {
  name     = "${var.eks_cluster_id}-xsp-external-dns-cross-account"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.aws_account_id}:role/${var.eks_cluster_id}-external-dns"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF

  depends_on = [aws_iam_role_policy_attachment.eks_role_policy]
}

resource "aws_iam_role_policy_attachment" "attach_route53_update_policy_to_cross_account_role" {
  role       = aws_iam_role.allow_external_dns_to_assume_role.name
  policy_arn = aws_iam_policy.allow_external_dns_route53_updates.arn

  depends_on = [aws_iam_role_policy_attachment.eks_role_policy]
}


resource "aws_iam_policy" "assume_external_dns_cross_account_role" {
  name        = "${var.eks_cluster_id}-assume-external-dns-cross-account-role"
  description = "Allows to assume the role inside the network account in order to managed Route53 entries"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "arn:aws:iam::${var.aws_network_account_id}:role/${var.eks_cluster_id}-xsp-external-dns-cross-account"
    }
  ]
}
EOF
}

resource "aws_iam_role" "external_dns" {
  name = "${var.eks_cluster_id}-external-dns"

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
          "${var.eks_oidc_issuer_url}:sub": "system:serviceaccount:kube-system:external-dns"
        }
      }
    }
  ]
}
EOF
}


# Allows eks external-dns to assume the role inside the network account in order to manage Route 53 entries
resource "aws_iam_role_policy_attachment" "eks_role_policy" {
  role       = aws_iam_role.external_dns.name
  policy_arn = aws_iam_policy.assume_external_dns_cross_account_role.arn

  depends_on = [aws_iam_policy.assume_external_dns_cross_account_role, aws_iam_role.external_dns]
}

# Kubernetes service account for external-dns controller
resource "kubernetes_service_account" "aws_external_dns_sa" {
  metadata {
    name        = local.service_account_name
    namespace   = "kube-system"
    annotations = { "eks.amazonaws.com/role-arn" : aws_iam_role.external_dns.arn }
  }
  automount_service_account_token = true
}

# Kubernetes cluster role for external-dns controller
resource "kubernetes_cluster_role" "external_dns" {
  metadata {
    name = "external-dns"
  }

  rule {
    api_groups = [""]
    resources  = ["services", "pods", "nodes", "endpoints"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.istio.io"]
    resources  = ["gateways"]
    verbs      = ["get", "list", "watch"]
  }
}


# Binds EKS cluster role with service account
resource "kubernetes_cluster_role_binding" "external_dns" {
  metadata {
    name = "external-dns"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.external_dns.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.aws_external_dns_sa.metadata[0].name
    namespace = kubernetes_service_account.aws_external_dns_sa.metadata[0].namespace
  }

  depends_on = [kubernetes_cluster_role.external_dns, kubernetes_service_account.aws_external_dns_sa]
}