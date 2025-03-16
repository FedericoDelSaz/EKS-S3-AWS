data "aws_caller_identity" "current" {}

# Reference the existing network resources from the S3 backend (network-creation.tfstate)
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "network-creation"  # S3 bucket name where the network state is stored
    key    = "network-creation.tfstate"  # Path to the state file in the bucket
    region = "eu-west-1"  # Region where the S3 bucket is located
    profile = "new-work-se-user"  # Profile used for accessing the state
    encrypt = true  # Optional, ensures the state file is encrypted in S3
  }
}