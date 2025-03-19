# EKS Cluster Configuration

This module configures essential services and networking for the **EKS cluster**.

## Overview


The configuration includes:
- **DNS Management** with AWS Route 53
- **SSL Certificates** using Cert-Manager and Let's Encrypt
- **Ingress Controller** with Nginx
- **Nginx-hello Application** that serves "Hello, World!" from a ConfigMap
- **Render-Image-Local-App** that exposes `image.jpg` from a local directory
- **Render-Image-App** that exposes `image.jpg` from an S3 bucket
- **Policy Enforcement** using Kyverno

## Resources Configured

### **Route 53 DNS Zone**
- Creates a **Route 53 hosted zone** for the public domain.
- Ensures DNS resolution for services within the cluster.

### **Cert-Manager ClusterIssuer**
- Sets up **Let's Encrypt ACME issuer** for automatic SSL certificate management.
- Uses **HTTP-01 challenge** via the **Nginx Ingress Controller**.

### **Nginx Ingress Controller**
- Deploys an **Ingress Controller** to manage external traffic.
- Routes requests to internal services securely.

### **Nginx-Hello Application**
- Deploys an **Nginx-based application** that serves a "Hello, World!" message from a ConfigMap.

### **Render-Image-Local-App**
- Deploys an application that serves an image (`image.jpg`) stored locally within the container.

### **Render-Image-App**
- Deploys an application that serves an image (`image.jpg`) stored in an S3 bucket.

### **Ingress Configuration**
- Defines an **Ingress resource** to expose applications via the configured domain.

### **Kyverno**
- Enforces security and configuration policies on Kubernetes resources.
- Ensures compliance with best practices for workloads and network policies.
- Automatically audits and remediates misconfigurations.

## Architecture

```mermaid
graph TD;
  A[Route 53 DNS Zone] -->|Resolves| B[EKS Cluster];
  B -->|Manages Certificates| C[Cert-Manager ClusterIssuer];
  C -->|Issues SSL Certificates| D[Let's Encrypt];
  B -->|Routes Traffic| E[Nginx Ingress Controller];
  B -->|CLusterPolicies| J[Kyverno];
  E -->|Exposes nginx-hello App| F[nginx-hello Application];
  E -->|Exposes render-image-local-app| G[Render-Image-Local-App];
  E -->|Exposes render-image-app| H[Render-Image-App];
  E -->|Manages Routing & SSL| I[Ingress Configuration];
  I -->|Uses SSL Certificates| C;
  J[Kyverno - ClusterPolicies];

```  

## Prerequisites
- **EKS Cluster** must be deployed.
- **Cert-Manager** must be installed.
- **Terraform & Kubectl** must be configured.
- **Kyverno** must be installed for policy enforcement.

## Security Considerations
- Uses **Let's Encrypt** for free SSL/TLS certificates.
- **Ingress rules** ensure controlled access.
- **DNS resolution** prevents misconfigured domains.
- **Kyverno policies** help enforce best practices for security, configurations, and compliance across Kubernetes resources.

[🔙 Return](../creation/README.md) | [➡️ Index](../../../../README.md)