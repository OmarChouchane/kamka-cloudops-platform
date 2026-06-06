terraform {
  backend "s3" {
    bucket         = "kamka-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "kamka-terraform-locks"
    encrypt        = true
  }
}
