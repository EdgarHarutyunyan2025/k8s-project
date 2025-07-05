data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket = "argicd-tfstate-bucket"
    key    = "eks/terraform.tfstate" # путь к файлу стейта в бакете
    region = "eu-central-1"
  }
}

