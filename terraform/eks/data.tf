terraform {
  backend "s3" {
    bucket = "argicd-tfstate-bucket"
    key    = "eks/terraform.tfstate"
    region = "eu-central-1"
  }
}
