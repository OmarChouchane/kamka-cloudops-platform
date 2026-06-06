terraform {
  backend "s3" {
    bucket         = "kamka-terraform-state-861648135209"
    key            = "dev/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "kamka-terraform-locks"
    encrypt        = true
  }
}