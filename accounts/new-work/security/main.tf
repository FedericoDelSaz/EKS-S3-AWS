module "new_work_kms_key" {
  source        = "../../../modules/aws-kms-key"
  account_alias = "workload-new-work"
}