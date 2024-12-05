
terraform {
  backend "s3" {
    bucket         = "faias-terraform-state"
    key            = "terraform/state/ansible-setup.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "faias-dynamodb"
  }
}
