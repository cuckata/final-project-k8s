
# Kubernetes Deployment Project

This guide outlines the steps to set up an AWS infrastructure using Terraform, build and push a Docker image to Amazon Elastic Container Registry (ECR), and deploy the application to Amazon Elastic Kubernetes Service (EKS).

## Prerequisites

1. AWS CLI installed and configured.  
2. Terraform installed.  
3. Docker installed.  
4. Kubernetes CLI (`kubectl`) installed.  

---

## Steps

### 1. Create S3 Bucket for Terraform State (Optional)  
1. Create an S3 bucket to store the `.tfstate` file:  
   ```
   aws s3api create-bucket --bucket my-terraform-state-cecko --region eu-central-1 --create-bucket-configuration LocationConstraint=eu-central-1
   ```  
2. Enable versioning for the S3 bucket:  
   ```
   aws s3api put-bucket-versioning --bucket my-terraform-state-cecko --versioning-configuration Status=Enabled
   ```  

### 2. Create DynamoDB Table for State Locking (Optional)  
1. Create a DynamoDB table to prevent concurrent Terraform operations:  
   ```bash
   aws dynamodb create-table \
       --table-name terraform-locks \
       --attribute-definitions AttributeName=LockID,AttributeType=S \
       --key-schema AttributeName=LockID,KeyType=HASH \
       --billing-mode PAY_PER_REQUEST
   ```  

### 3. Configure Terraform and Deploy Infrastructure  
1. Explanation of what is happening in `main.tf`:  
   - Configure the Terraform backend to use the S3 bucket for state storage (optional).  
   - Set up the provider.  
   - Create the following resources:  
     - ECR  
     - VPC  
     - EKS  

2. Run the Terraform commands from the root directory:  
   ```
   terraform init
   terraform plan
   terraform apply
   ```  
   This process will take approximately 15-20 minutes as the EKS takes a lot of time.

---

### 4. Build and Push Docker Image  
1. Build the Docker image using the provided `Dockerfile`:  
   ```
   docker build -t my-project .
   ```  

2. Authenticate Docker to Amazon ECR:  
   - Get your AWS Account ID:  
     ```
     aws sts get-caller-identity --query "Account" --output text
     ```  
   - Authenticate docker to ECR:  
     ```
     aws ecr get-login-password --region <your-region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com
     ```  

3. Tag the Docker image:  
   ```
   docker tag my-project:latest <account-id>.dkr.ecr.<region>.amazonaws.com/my-project:latest
   ```  

4. Push the tagged Docker image to ECR:  
   ```
   docker push <account-id>.dkr.ecr.<region>.amazonaws.com/my-project:latest
   ```  

5. Verify the image in ECR:  
   - Through CLI:  
     ```
     aws ecr describe-images --repository-name my-project
     ```  
   - Through AWS Management Console:  
     - Navigate to ECR.  
     - Open your registry and verify the image.

---

### 5. Deploy to EKS  
1. Apply the Kubernetes manifests:  
   ```
   kubectl apply -f k8s/deployment.yaml
   kubectl apply -f k8s/service.yaml
   ```  

2. Configure local access to the EKS cluster:  
   ```
   aws eks update-kubeconfig --region <your-region> --name <cluster-name>
   ```  

3. Verify connectivity:  
   ```
   kubectl get nodes
   kubectl get pods
   ```  

4. Get the DNS of the Load Balancer:  
   - through CLI
   ```
   aws elb describe-load-balancers --query "LoadBalancerDescriptions[*].{Name:LoadBalancerName,DNS:DNSName}" --output table
   ```
   - Through UI: Go to AWS > EC2 > Load Balancers > Copy the DNS name.

5. Open the application in your browser using the Load Balancer URL.

---

## Application URL

Access my deployed application at:  
http://a02efe548514541ae9bef05814b43377-1317879840.eu-central-1.elb.amazonaws.com/

---

Enjoy your deployed Kubernetes application!
