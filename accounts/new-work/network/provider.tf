provider "aws" {
  region     = "eu-west-1"
  access_key = ""
  secret_key = ""
  profile    = "new-work-se-user"

  default_tags {
    tags = {
      "created_by" = "Terraform"
    }
  }
}