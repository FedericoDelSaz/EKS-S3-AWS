data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "custom_kms_key_policy" {
  statement {
    sid = "Enable IAM User Permissions"
    actions = [
      "kms:*"
    ]

    resources = [
      "*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid = "Allow access through EBS for all principals in the account that are authorized to use EBS"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:CreateGrant",
      "kms:DescribeKey"
    ]

    resources = [
      "*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.current.account_id]
      variable = "kms:CallerAccount"
    }

    condition {
      test     = "StringEquals"
      values   = ["ec2.eu-central-1.amazonaws.com"]
      variable = "kms:ViaService"
    }
  }

  statement {
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]

    resources = [
      "*"
    ]

    principals {
      type        = "Service"
      identifiers = ["logs.eu-central-1.amazonaws.com"]
    }

    condition {
      test     = "ArnLike"
      variable = "kms:EncryptionContext:aws:logs:arn"

      values = [
        "arn:aws:logs:eu-central-1:${data.aws_caller_identity.current.account_id}:*"
      ]
    }
  }

  statement {
    actions = [
      "kms:GenerateDataKey*"
    ]

    resources = [
      "*"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"

      values = [
        "arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"
      ]
    }
  }
}
