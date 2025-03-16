terraform {
  backend "s3" {
    bucket  = "network-creation"
    key     = "network-creation.tfstate"
    region  = "eu-west-1"
    profile = "new-work-se-user"
    encrypt = true
  }
}