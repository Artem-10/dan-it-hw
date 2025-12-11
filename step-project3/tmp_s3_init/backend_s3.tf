resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = var.s3_bucket_name

  force_destroy = true

  tags = {
    Name = "TF state bucket for jenkins project"
    Environment = "DevOps project"
  }
}

resource "aws_s3_bucket_versioning" "versioning_enabled" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  block_public_acls      = true
  block_public_policy    = true
  ignore_public_acls     = true
  restrict_public_buckets = true
}


resource "aws_dynamodb_table" "terraform_locks" {
  name = "${var.s3_bucket_name}-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}