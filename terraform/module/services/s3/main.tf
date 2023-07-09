############
# MODULE: S3 bucket provisioning
# module input params defined in module specific variable.tf file 
# output value are defined in output.tf file 

resource "aws_s3_bucket" "perf-loadgen-s3-bucket" {
  bucket        = var.s3_bucker_name
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "perf-loadgen-s3-bucket-access" {
  bucket = aws_s3_bucket.perf-loadgen-s3-bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
}
