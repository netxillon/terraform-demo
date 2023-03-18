/*variable "s3_encrypt" {
  type = list(object({
    internal = number
    external = number
    protocol = string
  }))
  default = [
    {
      internal = 8300
      external = 8300
      protocol = "tcp"
    }
  ]
}*/

/*variable "s3_encrypt" {
  type = list(object({
    encrypt_type = string
  }))
  default = [
    {
      encrypt_type = "AES256"
    }
  ]
}*/

/*variable "s3_encrypt" {
  type = list
  default = [{
    apply_server_side_encryption_by_default = [{
      sse_algorithm     = "AES256"
      }]
  }]
}


resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.s3_demo1_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
      }
}
}*/

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.s3_demo1_bucket.bucket
  rule {
    filter {
        prefix = "configs/"
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

resource "aws_s3_bucket_intelligent_tiering_configuration" "example-filtered" {
  bucket = aws_s3_bucket.s3_demo1_bucket.id
  name   = "ImportantBlueDocuments"

  status = "Enabled"

  filter {
    prefix = "/"

    /*tags = {
      priority = "high"
      class    = "blue"
    }*/
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
