terraform {
  backend "s3" {
    bucket         = "task1-asg-tf-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "task1-asg-tf-locks"
    encrypt        = true
  }
}
