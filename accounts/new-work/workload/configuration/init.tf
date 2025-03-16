terraform {
  backend "s3" {
    bucket  = "workload-configuration"
    key     = "workload-configuration.tfstate"
    region  = "eu-west-1"
    profile = "new-work-se-user"
    encrypt = true
  }
}