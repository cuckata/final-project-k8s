# Kubernetes Deployment Project

This guide outlines the steps to automatically set up AWS infrastructure using Terraform, build and push a Docker image to Amazon ECR, and deploy the application to Amazon EKS using GitHub Actions.

## Prerequisites

1. AWS CLI installed and configured.  
2. Terraform installed.  
3. Docker installed.  
4. Kubernetes CLI (`kubectl`) installed.  
5. GitHub Actions enabled for the repository.

---

## Automated Pipeline Overview

This project uses GitHub Actions to automate the following steps:

1. **Terraform Infrastructure Setup**  
2. **Docker Image Build & Push to ECR**  
3. **Kubernetes Deployment to EKS**

---

## Steps

### 1. Terraform Infrastructure Setup

The infrastructure is deployed automatically via GitHub Actions using the Terraform configuration located in the `tf/` directory.

- **What happens in the Terraform step?**  
   - Terraform is used to create:
     - ECR repository for storing Docker images.
     - VPC and subnets.
     - EKS cluster
     - Necessary IAM roles and policies.

The `terraform` GitHub Action job handles the initialization and application of Terraform automatically.

### 2. Docker Image Build and Push

The Docker image is automatically built and pushed to Amazon ECR as part of the GitHub Actions pipeline.

- **Dockerfile**: The `Dockerfile` in the root directory defines how the Docker image is built.

- **GitHub Actions for Docker**:  
   - The `build-and-push` job automates:
     - Building the Docker image.
     - Logging into AWS ECR.
     - Tagging the image with the latest version.
     - Pushing the tagged image to ECR.

- **Verify Image in ECR**:  
   You can verify the image in the ECR repository either via the AWS CLI:
     ```bash
     aws ecr describe-images --repository-name my-project
     ```
   or through the AWS Management Console.

### 3. Kubernetes Deployment

After the Docker image is pushed to ECR, the deployment to EKS is automatically triggered by GitHub Actions.

- **Kubernetes Manifests**:  
   The Kubernetes manifests (`k8s/deployment.yaml` and `k8s/service.yaml`) define the app deployment and services.

- **GitHub Actions for Deployment**:  
   The `deploy-to-kubernetes` job handles:
     - Applying Kubernetes manifests to EKS.
     - Automatically configuring `kubectl` with AWS EKS credentials.

- **Verify Deployment**:  
   The pipeline will output logs of the deployment status. You can also check manually using `kubectl`:
     ```bash
     kubectl get nodes
     kubectl get pods
     ```

### 4. Load Balancer and Application Access

- **Find Load Balancer DNS**:  
   The DNS name of the load balancer that exposes the application can be found with the AWS CLI:
   ```bash
   aws elb describe-load-balancers --query "LoadBalancerDescriptions[*].{Name:LoadBalancerName,DNS:DNSName}" --output table
