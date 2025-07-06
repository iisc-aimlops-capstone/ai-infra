terraform {
  backend "s3" {
    bucket         = "s3b-iisc-aimlops-cap-tf-states"   # Your existing S3 bucket name
    key            = "aimlops/capstone/global/terraform.tfstate"   # Path to the state file within the bucket
    region         = "us-east-2"                   # Region where the bucket is located
    #profile        = "terraform-user"              # Optional: only if using AWS named profile
    encrypt        = true                          # Enable server-side encryption
    #dynamodb_table = "terraform-locks"             # Optional: for state locking
  }
}