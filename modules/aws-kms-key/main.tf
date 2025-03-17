resource "aws_kms_key" "this" {
  description              = var.description
  deletion_window_in_days  = var.deletion_window_in_days
  customer_master_key_spec = var.customer_master_key_spec
  enable_key_rotation      = var.enable_key_rotation
  policy                   = data.aws_iam_policy_document.custom_kms_key_policy.json
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.account_alias}"
  target_key_id = aws_kms_key.this.id
}

output "kms_key_arn" {
  value = aws_kms_key.this.arn
}