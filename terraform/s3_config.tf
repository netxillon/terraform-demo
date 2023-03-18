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
        prefix = "logs/"
    } # workaround error
    status = "Enabled"
    id     = "logs-rotation"
    # delete if objects are older than noncurrent_days and older than n-newer_noncurrent_versions
    noncurrent_version_expiration {
      noncurrent_days           = 180
      newer_noncurrent_versions = 2
    }
    # move to standard IA if older than 30 days for all noncurrent versions.
    # storage_class are GLACIER | STANDARD_IA | ONEZONE_IA | INTELLIGENT_TIERING | DEEP_ARCHIVE | GLACIER_IR

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = 60
      storage_class   = "GLACIER"
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
