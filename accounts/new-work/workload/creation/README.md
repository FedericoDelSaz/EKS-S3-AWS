# EKS Cluster Setup with Terraform

This repository contains the necessary Terraform configurations to set up an Amazon EKS cluster with best practices in security, scalability, and maintainability. The setup includes network configurations, IAM roles, and EKS node group setup.

## File Structure Overview

- **`data.tf`**: This file defines data sources to pull necessary resources like AWS KMS key, VPC, ECR authorization tokens, and network configuration for the existing setup from the `network-creation.tfstate` file.

- **`main.tf`**: The primary configuration file where the EKS cluster is created, IAM roles are defined, and policies are attached to the node group. It also defines the cluster's configuration (endpoint access, encryption, and add-ons).

- **`local.tf`**: Defines local variables such as the desired EKS version (1.32), CIDR blocks, and subnet IDs, which are used for configuring the EKS cluster and node groups.

- **`variables.tf`**: This file contains input variables such as `cluster_name` and `cidr_block`, allowing for parameter reuse throughout the configurations.

- **`output.tf`**: Outputs the details of the EKS cluster and node group, including their names, ARNs, and endpoints, for easy reference after Terraform applies the configuration.

## Prerequisites

Before using this configuration, ensure you have the following:

- **Terraform**: Installed and configured to interact with your AWS account.
- **AWS CLI**: Installed and configured with appropriate credentials.
- **IAM Role Permissions**: Ensure that your AWS account or IAM user has the necessary permissions to create and manage EKS clusters, IAM roles, VPCs, and other AWS resources.

## Setup and Configuration

1. **Clone the Repository**:
   ```bash
   git clone <repository_url>
   cd <repository_directory>
   ```

2. **Initialize Terraform**:
   Run the following command to initialize the Terraform working directory:
   ```bash
   terraform init
   ```

3. **Configure Input Variables**:
   Update the `variables.tf` file with your desired values for `cluster_name` and `cidr_block`, or provide them via environment variables or a `terraform.tfvars` file.

4. **Apply the Terraform Configuration**:
   To create the resources in your AWS account, run:
   ```bash
   terraform apply
   ```

   Terraform will display a plan and ask for confirmation to proceed. Type `yes` to proceed with the creation.

5. **Access the Cluster**:
   Once the Terraform plan is applied successfully, use the output information provided in `output.tf` (EKS cluster name, ARN, and endpoint) to access the newly created EKS cluster.

## Outputs

After the configuration is applied, the following outputs will be provided:

- `eks_cluster_name`: The name of the EKS cluster.
- `eks_cluster_arn`: The ARN of the EKS cluster.
- `eks_cluster_endpoint`: The endpoint URL of the EKS cluster.
- `node_group_name`: The name of the node group associated with the EKS cluster.
- `node_group_arn`: The ARN of the node group.

## Clean Up

To delete the resources created by Terraform, run the following command:
```bash
terraform destroy
```

This will prompt for confirmation before destroying the resources.