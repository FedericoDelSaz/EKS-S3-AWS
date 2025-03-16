# AWS EKS Networking Infrastructure with Terraform

## 🛠 Breakdown of the Terraform Script

### 1️⃣ VPC Creation
- A **VPC (Virtual Private Cloud)** is created with the CIDR block `10.0.0.0/16`.
- This serves as the **networking foundation** for the EKS cluster.

### 2️⃣ Public and Private Subnets
- Two **public subnets** (`10.0.1.0/24`, `10.0.2.0/24`) are created in **different Availability Zones**.
  - Public subnets allow **direct internet access**.
- Two **private subnets** (`10.0.3.0/24`, `10.0.4.0/24`) are also created in different AZs.
  - Private subnets are for **internal workloads** (e.g., worker nodes) without direct internet access.

### 3️⃣ Internet Gateway (IGW)
- An **Internet Gateway (IGW)** is attached to the VPC.
- It enables **public subnets** to access the internet.

### 4️⃣ NAT Gateway
- A **NAT Gateway** is created in the **public subnet**.
- Allows **private subnets** to access the internet **securely** (e.g., for software updates) while remaining **isolated from inbound connections**.

### 5️⃣ Route Tables
- A **Public Route Table** is created:
  - Routes internet traffic (`0.0.0.0/0`) through the **Internet Gateway (IGW)**.
  - Associated with **public subnets**.
- A **Private Route Table** is created:
  - Routes internet traffic (`0.0.0.0/0`) through the **NAT Gateway**.
  - Associated with **private subnets**.

## 📜 Usage Instructions

### 1️⃣ Prerequisites
Ensure you have the following installed:
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [AWS CLI](https://aws.amazon.com/cli/)
- An AWS account with the necessary permissions

### 2️⃣ Clone the Repository
```sh
git clone <repository-url>
cd <repository-folder>
```

### 3️⃣ Set Up Terraform Variables
Modify the `variables.tf` file to customize the **CIDR block, AWS region, and Availability Zones**.

### 4️⃣ Initialize Terraform
```sh
terraform init
```

### 5️⃣ Plan and Apply the Configuration
```sh
terraform plan
terraform apply -auto-approve
```

### 6️⃣ Verify the Deployment
Check the created resources in the AWS Console:
- **VPC** under the VPC service
- **Subnets** under the Subnets section
- **Route Tables and Gateways** under Networking
