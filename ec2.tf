resource "aws_s3_bucket" "grafana_bucket" {
  bucket        = "brinks-grafana-${var.user_suffix}"
  force_destroy = true # permite destruir mesmo com arquivos dentro
}

# FAZ O UPLOAD AUTOMÁTICO DO JSON A CADA APPLY
resource "aws_s3_object" "dashboard_infra" {
  bucket = aws_s3_bucket.grafana_bucket.bucket
  key    = "brinks-infra.json"
  source = "${path.module}/deploy_temporario/brinks-infra.json"
  etag   = filemd5("${path.module}/deploy_temporario/brinks-infra.json")
}

resource "aws_s3_object" "dashboard_analytics" {
  bucket = aws_s3_bucket.grafana_bucket.bucket
  key    = "brinks-analytics.json"
  source = "${path.module}/deploy_temporario/brinks-analytics.json"
  etag   = filemd5("${path.module}/deploy_temporario/brinks-analytics.json")
}

resource "aws_instance" "brinks-db" {
  ami                         = var.ami_ubuntu
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.private_subnets[0]
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.db_sg.id]
  key_name                    = var.instance_key

  user_data_base64 = base64gzip(templatefile("${path.module}/deploy_temporario/database.sh.tftpl", {
    user_suffix      = var.user_suffix
    init_sql_content = file("${path.module}/deploy_temporario/sql/init.sql"),
    compose_backend  = file("${path.module}/deploy_temporario/docker-compose-db.yml")
    backup_script = templatefile("${path.module}/deploy_temporario/backup.sh.tftpl", {
      user_suffix    = var.user_suffix
      gmail_user     = var.gmail_user
      gmail_password = var.gmail_password
    })
    aws_access_key    = var.aws_access_key
    aws_secret_key    = var.aws_secret_key
    aws_session_token = var.aws_session_token
    gmail_user        = var.gmail_user
    gmail_password    = var.gmail_password
    cron_script       = file("${path.module}/deploy_temporario/cron.sh")
  }))

  depends_on = [module.vpc]

  iam_instance_profile = "LabInstanceProfile"
  tags                 = { Name = "brinks-db-server" }
}

resource "aws_instance" "brinks-pub-1" {
  ami                         = var.ami_ubuntu
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.pub_sg.id]
  associate_public_ip_address = true
  key_name                    = var.instance_key
  iam_instance_profile        = "LabInstanceProfile"

  user_data = templatefile("${path.module}/deploy_temporario/frontend.sh.tftpl", {
    lb_dns_name      = aws_lb.brinks_alb.dns_name,
    compose_frontend = file("${path.module}/deploy_temporario/docker-compose-frontend.yml"),
    api_gateway_url  = "${aws_apigatewayv2_api.lambda_api.api_endpoint}/solicitar-relatorio",
    user_suffix      = var.user_suffix
    db_host          = aws_instance.brinks-db.private_ip
  })

  tags = {
    Name = "${var.instance_name_pub}-1"
  }
}


# 2. Instâncias de Backend (agora usando o template)
resource "aws_instance" "brinks-pri-1" {
  ami                    = var.ami_ubuntu
  instance_type          = var.instance_type
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.pri_sg.id]
  key_name               = var.instance_key

  user_data = templatefile("${path.module}/deploy_temporario/backend.sh.tftpl", {
    compose_backend = templatefile("${path.module}/deploy_temporario/docker-compose-backend.yml", {
      api_url        = aws_apigatewayv2_stage.lambda_stage.invoke_url,
      db_host        = aws_instance.brinks-db.private_ip
      bucket_trusted = aws_s3_bucket.bucket_trusted.bucket, # usa o nome criado pelo recurso S3
      bucket_client  = aws_s3_bucket.bucket_client.bucket
    }),
  })

  depends_on = [module.vpc]

  iam_instance_profile = "LabInstanceProfile"

  tags = { Name = "${var.instance_name_pri}-1" }
}

resource "aws_instance" "brinks-pri-2" {
  ami                    = var.ami_ubuntu
  instance_type          = var.instance_type
  subnet_id              = module.vpc.private_subnets[1]
  vpc_security_group_ids = [aws_security_group.pri_sg.id]
  key_name               = var.instance_key

  user_data = templatefile("${path.module}/deploy_temporario/backend.sh.tftpl", {
    # exemplo de passagem no templatefile (em ec2.tf para brinks-pri)
    compose_backend = templatefile("${path.module}/deploy_temporario/docker-compose-backend.yml", {
      api_url        = aws_apigatewayv2_stage.lambda_stage.invoke_url,
      db_host        = aws_instance.brinks-db.private_ip
      bucket_trusted = aws_s3_bucket.bucket_trusted.bucket, # usa o nome criado pelo recurso S3
      bucket_client  = aws_s3_bucket.bucket_client.bucket
    }),
  })

  depends_on = [
    module.vpc,
  ]

  iam_instance_profile = "LabInstanceProfile"

  tags = { Name = "${var.instance_name_pri}-2" }
}

