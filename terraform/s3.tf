resource "aws_s3_bucket" "s3_demo1_bucket" {
  bucket = "${var.org}-${var.environment}-demo1-zone"
}

resource "aws_s3_bucket" "s3_demo2_bucket" {
  bucket = "${var.org}-${var.environment}-demo2-zone"
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.s3_demo1_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "s3_bucket2_public_access_block" {
  bucket                  = aws_s3_bucket.s3_demo2_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
