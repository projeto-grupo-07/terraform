resource "aws_s3_bucket" "bucket_raw" {
  bucket = "brinks-bucket-raw"
  tags = { Name = "MyS3Bucket" }
  force_destroy = true
}

resource "aws_s3_bucket" "bucket_trusted" {
  bucket = "brinks-bucket-trusted"
  tags = { Name = "MyS3Bucket" }
  force_destroy = true
}

resource "aws_s3_bucket" "bucket_client" {
  bucket = "brinks-bucket-client"  
  tags = { Name = "MyS3Bucket" }
  force_destroy = true
}