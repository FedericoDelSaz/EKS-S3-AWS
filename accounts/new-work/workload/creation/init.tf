terraform {
  backend "s3" {
    bucket  = "workload-creation"
    key     = "workload-creation.tfstate"
    region  = "eu-west-1"
    profile = "new-work-se-user"
    encrypt = true
  }
}