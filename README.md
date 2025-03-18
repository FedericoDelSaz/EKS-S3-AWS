# EKS Cluster Setup and S3 Image Display Service

## Overview

In this interview challenge, you are tasked with creating a fully functional Kubernetes cluster on AWS using **Amazon EKS** (Elastic Kubernetes Service). The main goal of the challenge is to deploy a service that fetches and displays an image stored in an **S3** (Simple Storage Service) bucket. You will utilize the **mountpoint-s3-csi-driver**, enabling Kubernetes pods to mount S3 buckets as file systems.

The challenge tests your understanding of the following:
- **Kubernetes resource management** and best practices
- **AWS services**, such as EKS and S3
- Integration of third-party drivers like the **mountpoint-s3-csi-driver**
- Ensuring **security**, **scalability**, **documentation**, and **maintainability**

The task also requires you to demonstrate a solution that avoids the use of **InitContainers**, encouraging you to explore other methods for resource initialization.

By the end of the challenge, you should have a working service that:
- Displays an image from an S3 bucket.
- Integrates Kubernetes with AWS services.
- Uses a public domain for external access.

Please ensure your solution is properly documented, secure, and scalable. Additionally, include an **architecture diagram** to outline the details of your setup.

## Architecture Diagram

```mermaid
graph TD;

  %% Networking Box
  subgraph Networking
    A[VPC] -->|Public| B[Public Subnet 1]
    A -->|Public| C[Public Subnet 2]
    A -->|Public| D[Public Subnet 3]
    A -->|Private| E[Private Subnet 1]
    A -->|Private| F[Private Subnet 2]
    A -->|Private| G[Private Subnet 3]
    B -->|Route| H[Public Route Table]
    C -->|Route| H
    D -->|Route| H
    E -->|Route| I[Private Route Table]
    F -->|Route| I
    G -->|Route| I
    H -->|Internet Access| J[Internet Gateway]
    I -->|Outbound Access| K[NAT Gateway]
  end

  %% Security Box
  subgraph Security
    A -->|Encrypts| C1[KMS Key - workload-new-work]
    A -->|Certificate Management| G1[Cert-Manager]
    C2[Cert-Manager ClusterIssuer] -->|Issues SSL Certificates| D2[Let's Encrypt]
  end

  %% Kubernetes Box
  subgraph Kubernetes
    A[EKS Cluster] -->|Node Groups| B1[Managed Worker Nodes]
    B1 -->|Authenticates| D1[AWS IAM & RBAC]
    A -->|Persistent Storage| E1[AWS S3 CSI Driver]
    E1 -->|Creates| F1[S3 Bucket]
    A2[Route 53 DNS Zone] -->|Resolves| B2[EKS Cluster]
    B2 -->|Routes Traffic| E2[Nginx Ingress Controller]
    E2 -->|Exposes App| F2[Hello-World Application]
    E2 -->|Manages Routing & SSL| G2[Ingress Configuration]
    G2 -->|Uses SSL Certificates| C2
  end

  %% Connecting the diagrams
  B2 -->|Uses| A
  F1 -->|Uses| E2
```

## Links to Related Documents

- [Network README.md](./accounts/new-work/network/README.md)
- [Security README.md](./accounts/new-work/security/README.md)
- [Workload Creation README.md](./accounts/new-work/workload/creation/README.md)
- [Workload Configuration README.md](./accounts/new-work/workload/configuration/README.md)

[➡️ Next](./accounts/new-work/network/README.md)