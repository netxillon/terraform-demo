resource "aws_s3_bucket" "s3_demo1_bucket" {
  bucket = "${var.org}-${var.environment}-demo1-zone"
}

resource "aws_s3_bucket" "s3_demo2_bucket" {
  bucket = "${var.org}-${var.environment}-demo2-zone"
}

locals {
    buckets = [aws_s3_bucket.s3_demo1_bucket, aws_s3_bucket.s3_demo2_bucket]
    }

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  for_each = {for idx, bucket in local.buckets: idx => bucket}
  bucket                  = each.value.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.s3_demo1_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}
