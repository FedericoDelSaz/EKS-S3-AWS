resource "aws_s3_bucket" "s3_bucket_driver" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

# S3 Bucket policy to allow access from the EKS service account used by the CSI driver
resource "aws_s3_object" "bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket_driver.bucket
  key    = "bucket-policy.json"
  acl    = "private"
  content = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": "*",
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.s3_bucket_driver.bucket}/*",
        "Condition": {
          "StringEquals": {
            "aws:PrincipalTag/eks.amazonaws.com/serviceaccount": "true"
          }
        }
      }
    ]
  }
  EOF
}

# IAM Policy for S3 CSI Driver
resource "aws_iam_policy" "s3_policy" {
  name        = "${var.eks_cluster_name}-s3-access-policy"
  description = "IAM policy for S3 access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "MountpointFullBucketAccess",
        Effect = "Allow",
        Action = [
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${var.bucket_name}"
        ],
      },
      {
        Sid    = "MountpointFullObjectAccess",
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:AbortMultipartUpload",
          "s3:DeleteObject",
        ],
        Resource = [
          "arn:aws:s3:::${var.bucket_name}/*"
        ],
      },
    ],
  })
}

resource "aws_iam_role" "s3_csi_driver" {
  name               = "${var.eks_cluster_name}-s3-csi-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.this.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            "${replace(data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:s3-csi-*",
            "${replace(data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_role_attachment" {
  policy_arn = aws_iam_policy.s3_policy.arn
  role       = aws_iam_role.s3_csi_driver.name
}

# EKS Addon for S3 CSI Driver
resource "aws_eks_addon" "s3_csi" {
  cluster_name                = data.aws_eks_cluster.eks_cluster.id
  addon_name                  = "aws-mountpoint-s3-csi-driver"
  addon_version               = data.aws_eks_addon_version.s3_csi.version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  service_account_role_arn = aws_iam_role.s3_csi_driver.arn
}