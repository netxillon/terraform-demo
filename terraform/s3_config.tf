
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.s3_demo1_bucket.bucket
  
  rule {
    filter {
        prefix = "/"
    }
    status = "Enabled"
    id     = "datazone-cleanup" #lion-dev-data-zone
    
    noncurrent_version_expiration {
      noncurrent_days           = "${var.expiration_days}"
      #newer_noncurrent_versions = 2
    }
    
    noncurrent_version_transition {
      noncurrent_days = "${var.days_to_infreq}"
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = "${var.days_to_glacier}"
      storage_class   = "GLACIER"
    }

    noncurrent_version_transition {
      noncurrent_days = "${var.days_to_deep_achive}"
      storage_class   = "DEEP_ARCHIVE"
    }
    
  }
}

/*resource "aws_s3_bucket_lifecycle_configuration" "athena_cleanup" {
  bucket = aws_s3_bucket.s3_demo1_bucket.bucket
  
  rule {
    filter {
        prefix = "scratchpad-spills/"
    }
    status = "Enabled"
    id     = "clean-athean-spills" #lion-dev-data-zone
    # delete if objects are older than noncurrent_days and older than n-newer_noncurrent_versions
    noncurrent_version_expiration {
      noncurrent_days           = "${var.tmp_clean_days}"
      newer_noncurrent_versions = 1
    }
  }  

}

resource "aws_s3_bucket_lifecycle_configuration" "aera_cleanup" {
  bucket = aws_s3_bucket.s3_demo1_bucket.bucket
  
  rule {
    filter {
        prefix = "/"
    }
    status = "Enabled"
    id     = "clean-athean-spills" #lion-athena-dev-spill
    # delete if objects are older than noncurrent_days and older than n-newer_noncurrent_versions
    noncurrent_version_expiration {
      noncurrent_days           = "${var.tmp_clean_days}"
      newer_noncurrent_versions = 1
    }
  }
}*/

resource "aws_s3_bucket_intelligent_tiering_configuration" "example-filtered" {
  for_each = {for idx, bucket in local.buckets: idx => bucket}
  bucket                  = each.value.id
  #bucket = aws_s3_bucket.s3_demo1_bucket.id
  name   = "rule-${each.value.id}"

  status = "Enabled"

  filter {
    prefix = "/"
    
  }

  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = 180
  }
  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 125
  }
  
}
