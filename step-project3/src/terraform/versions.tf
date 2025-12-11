terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.99.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.1.0"
    }
  }
  backend "s3" {
    bucket         = "tf-state-jenkins-pipeline-1223334444"
    key            = "terraform/jenkins/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "tf-state-jenkins-pipeline-1223334444-lock"
  }
}

provider "aws" {
  region = var.aws_region
}