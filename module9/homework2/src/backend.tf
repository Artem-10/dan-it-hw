terraform {
  backend "s3" {
    bucket = "terraform-state-danit10-devops"
    key = "artem.j@icloud.com/terraform.tfstate"
    region = "eu-central-1"
  }
}