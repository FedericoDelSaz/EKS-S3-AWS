terraform {
  backend "s3" {
    bucket  = "security-creation"
    key     = "security-creation.tfstate"
    region  = "eu-west-1"
    profile = "new-work-se-user"
    encrypt = true
  }
}