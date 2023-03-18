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

variable "s3_encrypt" {
  type = list
  default = [{
    apply_server_side_encryption_by_default = [{
      sse_algorithm     = "AES256"
    }]
  }]
}


resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.s3_demo1_bucket.id

  rule = [ "${var.s3_encrypt}" ]
  
}