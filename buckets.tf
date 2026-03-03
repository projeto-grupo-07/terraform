resource "aws_s3_bucket" "bucket1" {
  bucket = "brinks-bucket-1"
  tags = { Name = "MyS3Bucket" }
}

resource "aws_s3_bucket" "bucket2" {
  bucket = "brinks-bucket-2"
  tags = { Name = "MyS3Bucket" }
}

resource "aws_s3_bucket" "bucket3" {
  bucket = "brinks-bucket-3"  
  tags = { Name = "MyS3Bucket" }
}