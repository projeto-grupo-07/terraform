resource "aws_s3_bucket" "bucket_raw" {
  bucket        = "brinks-bucket-raw-${var.user_suffix}"
  tags          = { Name = "MyS3Bucket" }
  force_destroy = true
}

resource "aws_s3_bucket" "bucket_trusted" {
  bucket        = "brinks-bucket-trusted-${var.user_suffix}"
  tags          = { Name = "MyS3Bucket" }
  force_destroy = true
}

resource "aws_s3_bucket" "bucket_client" {
  bucket        = "brinks-bucket-client-${var.user_suffix}"
  tags          = { Name = "MyS3Bucket" }
  force_destroy = true
}

resource "aws_s3_bucket" "bucket_backup_database" {
  bucket        = "brinks-bucket-backup-database-${var.user_suffix}"
  tags          = { Name = "MyS3Bucket" }
  force_destroy = true
}