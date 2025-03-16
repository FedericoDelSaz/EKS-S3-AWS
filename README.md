# EKS Image Fetching App with S3 Integration

## Overview

This project demonstrates how to set up an Amazon EKS cluster on AWS, deploy a service that fetches and displays an image from an S3 bucket, and integrates the `mountpoint-s3-csi-driver` for seamless S3 mounting inside Kubernetes pods. This solution highlights security best practices with IAM roles for service accounts (IRSA) and scalable architecture using Kubernetes and AWS services.

## Architecture

- **Amazon EKS Cluster**: A managed Kubernetes cluster running on AWS.
- **mountpoint-s3-csi-driver**: A Container Storage Interface (CSI) driver for mounting S3 buckets as persistent volumes within Kubernetes pods.
- **Kubernetes Deployment**: A deployment (e.g., Flask app or Nginx) that fetches and displays an image from the S3 bucket.
- **ALB Ingress**: AWS Application Load Balancer (ALB) for exposing the application publicly.
- **IAM Roles for Service Accounts (IRSA)**: Secure access to S3 using IAM roles assigned to Kubernetes service accounts.

## Steps to Deploy

### 1. Provision EKS Cluster using Terraform

First, you need to set up your Terraform configuration to provision the EKS cluster. Use the following Terraform commands to initialize and apply the configuration.

1. **Initialize Terraform:**

```bash
terraform init
```

This command initializes your Terraform working directory and downloads the necessary provider plugins.

2. **Apply Terraform Configuration:**

```bash
terraform apply
```

Terraform will provision the EKS cluster and the associated resources, including the IAM roles and policies. Once the provisioning is complete, you will have the EKS cluster running.

### 2. Deploy mountpoint-s3-csi-driver

Deploy the `mountpoint-s3-csi-driver` as a DaemonSet in the EKS cluster. Ensure that the correct IAM permissions are set via an OIDC identity provider to grant access to the S3 bucket.

```bash
kubectl apply -k github.com/kubernetes-sigs/sig-storage/csi-driver-s3/deploy/kubernetes/overlays/aws
```

### 3. Deploy Application

Create a Kubernetes Deployment (Flask app or Nginx) that serves the image fetched from an S3 bucket. The pod should mount the S3 bucket as a volume using the `mountpoint-s3-csi-driver`.

Here’s an example of a simple deployment manifest:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: image-fetcher
spec:
  replicas: 1
  selector:
    matchLabels:
      app: image-fetcher
  template:
    metadata:
      labels:
        app: image-fetcher
    spec:
      containers:
      - name: flask-app
        image: my-flask-app
        volumeMounts:
        - mountPath: /mnt/s3
          name: s3-volume
      volumes:
      - name: s3-volume
        csi:
          driver: mountpoint-s3.csi.aws.com
          volumeHandle: s3://my-bucket-name
```

### 4. Expose the Service Publicly

Use the AWS Load Balancer Controller to create an ALB Ingress for exposing the service publicly. Also, register a custom domain with Route 53 and attach an SSL certificate using AWS ACM.

Example Ingress:

```bash
kubectl apply -f ingress.yaml
```

### 5. Security and Best Practices

- **IAM Least Privilege**: Ensure that IAM roles for S3 access are scoped to the required permissions.
- **Autoscaling**: Use **Karpenter** to enable node autoscaling in the EKS cluster based on demand.
- **Helm**: Deploy the infrastructure and application using Helm charts to ensure repeatability and consistency.
- **Observability**: Integrate with Prometheus, Grafana, and/or AWS CloudWatch for monitoring and alerting.

## Next Steps

You can customize the following:

- **Terraform/IaC Scripts**: Automate provisioning and setup.
- **Kubernetes Manifests**: Customize the application, deployment, and ingress.
- **Architecture Diagram**: Visualize the architecture for better understanding.

## Architecture Diagram

The architecture consists of:

- EKS Cluster with managed worker nodes.
- `mountpoint-s3-csi-driver` to mount S3 buckets as volumes.
- A Flask app or Nginx container that fetches images from the S3 bucket and serves them.
- AWS ALB Ingress to expose the application publicly.
- Route 53 and ACM for domain management and SSL certificates.
- **IRSA** for secure IAM permissions.

## Tools and Technologies

- AWS EKS
- `mountpoint-s3-csi-driver`
- AWS Load Balancer Controller (ALB Ingress)
- Route 53 and ACM for domain and SSL management
- Helm for deployment
- **Terraform** for provisioning

---