# AWS KMS Key Module for EKS Encryption

This module provisions an AWS Key Management Service (KMS) key to be used for encrypting secrets within an Amazon EKS cluster. The key is created with a custom policy, alias, and rotation enabled for enhanced security.

## Overview
- Creates a Customer Managed KMS Key with a specified description and alias.
- Enables automatic key rotation for improved security.
- Defines an IAM policy for controlling access to the key.
- Integrates the KMS key with the EKS cluster to encrypt secrets.

## Features
- Customizable alias for easy identification.
- Supports automatic key rotation.
- Configurable deletion window.
- Restricts access via IAM policies.
- Used in EKS cluster for secrets encryption.

## Resources Created
- **AWS KMS Key** (`aws_kms_key.this`): The primary encryption key.
- **AWS KMS Alias** (`aws_kms_alias.this`): A human-readable alias for the key.
- **IAM Policy**: Defines access control for the key.

## Usage in EKS Cluster
The created KMS key is used to encrypt secrets in an Amazon EKS cluster using the following configuration:

```hcl
module "eks" {
  source = "../../../modules/eks"
  
  cluster_encryption_config = {
    provider_key_arn = data.aws_kms_key.new_work_kms_key.arn
    resources        = ["secrets"]
  }
}
```

This ensures that Kubernetes secrets stored in etcd are encrypted using the KMS key.

## Outputs
- `kms_key_arn`: The ARN of the created KMS key.

## Security Considerations
- IAM policy restricts access to authorized users and services.
- Automatic key rotation is enabled to enhance security.
- The KMS key is used to encrypt sensitive data within the EKS cluster.

## Requirements
- Terraform >= 1.0.0
- AWS CLI configured with appropriate permissions

[🔙 Return](../network/README.md) | [➡️ Next](../workload/creation/README.md)