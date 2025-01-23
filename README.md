<!-- 
1.first we create S3 bucket in AWS for terraform in which we will keep the .tfstate file (NOT MANDATORY, YOU CAN KEEP YOUR .tfstate FILE LOCAL)
    aws s3api create-bucket --bucket my-terraform-state-cecko --region eu-central-1 --create-bucket-configuration LocationConstraint=eu-central-1
2.enable versioning on the newly created S3 bucket (NOT MANDATORY, ONLY NICE TO DO IF YOU DO STEP 1)
    aws s3api put-bucket-versioning --bucket my-terraform-state-cecko --versioning-configuration Status=Enabled
3.create a DynamoDb table to enable state locking and prevent concurrent operations (NOT MANDATORY, ONLY NICE TO DO IF YOU DO STEP 1 & 2)
    aws dynamodb create-table \
      --table-name terraform-locks \
      --attribute-definitions AttributeName=LockID,AttributeType=S \
      --key-schema AttributeName=LockID,KeyType=HASH \
      --billing-mode PAY_PER_REQUEST
4.basic explanation of whats happening in main.tf:
    -config the terraform backend to use S3 for the tfstate (you should comment this one out if you missed first 3 steps)
    -set provider
    -create ECR resource
    -create VPC 
    -create EKS     
5.go to the root dir of the project and run the terraform flow (it will take ~15-20 mins)
    -terraform init
    -terraform plan
    -terraform apply 
6.now the infrastructure is up
    -ECR is created
    -VPC is created
    -EKS is created
7.dockerfile is already created, just run docker build command to build an image from the app
8.image is made, now we need to authenticate docker to ECR
    -first run this command, it outputs AccountId which will be needed for next step
        -aws sts get-caller-identity —query “Account” —output text 
    -now run the get-login-password and auth command
        -aws ecr get-login-password --region <YOUR-REGION> | docker login --username AWS --password-stdin <YOUR-ACCOUNT-ID>.dkr.ecr.<YOUR-REGION>.amazonaws.com
    -output is Login succeeded
9.tag the docker image that we created earlier
    -docker tag my-project:latest <YOUR-ACCOUNT-ID>.dkr.ecr.<YOUR-REGION>.amazonaws.com/<YOUR-ECR-REPO>
10.push the tagged docker image to ECR
    -docker push <YOUR-ACCOUNT-ID>.dkr.ecr.<YOUR-REGION>.amazonaws.com/<YOUR-ECR-REPO>
11.verify the docker image is present in ECR
    -through CLI, run this command
      -aws ecr describe-images --repository-name <YOUR-ECR-REPO>
    -through UI
      -open AWS> go to ECR > open your registry > verify the image
12. EKS is now setup, so go to the k8s dir and run 
    -kubectl apply -f deployment.yaml
    -kubectl apply -f service.yaml
13.you need your local system to communicate with EKS cluster, so run this command
    -aws eks update-kubeconfig --region <YOUR-REGION> --name <YOUR-EKS-CLUSTER-NAME>
    -verify connectivity by running kubectl get nodes | kubectl get pods
14.go to AWS > EC2 > Load Balancers and get the DNS of your new DNS
15.open the URL in browser 
16.ENJOY! 

THE URL FOR MY APP IS http://a02efe548514541ae9bef05814b43377-1317879840.eu-central-1.elb.amazonaws.com/
 -->
