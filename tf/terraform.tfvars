# terraform.tfvars
aws_region         = "eu-central-1"
backend_bucket     = "my-terraform-state-cecko"
backend_key        = "myproject/prod/terraform.tfstate"
backend_region     = "eu-central-1"
backend_dynamodb_table = "terraform-locks"