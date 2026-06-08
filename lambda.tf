resource "aws_lambda_function" "lambda_raw" {
  filename      = "lambdas/lambda_raw.zip"
  function_name = "lambda-raw"
  role          = data.aws_iam_role.lab_role.arn
  handler       = "lambda_raw.lambda_handler"
  runtime       = "python3.12"
  memory_size   = 512
  timeout       = 60

  layers = ["arn:aws:lambda:us-east-1:336392948345:layer:AWSSDKPandas-Python312:14"]

  environment {
    variables = {
      S3_BUCKET = aws_s3_bucket.bucket_raw.bucket
      S3_PREFIX = "importacao" # Aspas adicionadas        # Aspas adicionadas (Terraform exige string) isso vai mudar
    }
  }

  source_code_hash = filebase64sha256("lambdas/lambda_raw.zip")
}

resource "aws_lambda_function_url" "lambda_raw_url" {
  function_name      = aws_lambda_function.lambda_raw.function_name
  authorization_type = "AWS_IAM"

  cors {
    allow_origins = ["*"]
    allow_methods = ["POST"]
    allow_headers = ["content-type"]
  }
}

resource "aws_lambda_function" "lambda_trusted" {
  filename      = "lambdas/lambda_trusted.zip"
  function_name = "lambda-trusted"
  role          = data.aws_iam_role.lab_role.arn
  handler       = "lambda_trusted.lambda_handler"
  runtime       = "python3.12"
  memory_size   = 512
  timeout       = 60

  layers = ["arn:aws:lambda:us-east-1:336392948345:layer:AWSSDKPandas-Python312:14"]

  environment {
    variables = {
      BUCKET_TRUSTED = aws_s3_bucket.bucket_trusted.bucket
    }
  }

  source_code_hash = filebase64sha256("lambdas/lambda_trusted.zip")
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_trusted.function_name # Modificado para lambda_trusted
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket_raw.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket_raw.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_trusted.arn # Modificado para lambda_trusted
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "importacao/"
    filter_suffix       = ".csv"
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
