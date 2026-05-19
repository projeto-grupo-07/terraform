resource "aws_instance" "brinks-db" {
  ami                         = var.ami_ubuntu
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.private_subnets[0]
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.db_sg.id]
  key_name                    = var.instance_key

  user_data_base64 = base64encode(templatefile("${path.module}/deploy_temporario/database.sh.tftpl", {
    init_sql_content = file("${path.module}/deploy_temporario/sql/init.sql"),
    compose_backend  = file("${path.module}/deploy_temporario/docker-compose-db.yml")
  }))

  depends_on = [module.vpc]

  tags = { Name = "brinks-db-server" }
}

resource "aws_instance" "brinks-pub-1" {
  ami                         = var.ami_ubuntu
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.pub_sg.id]
  associate_public_ip_address = true
  key_name                    = var.instance_key

  user_data = templatefile("${path.module}/deploy_temporario/frontend.sh.tftpl", {
    lb_dns_name      = aws_lb.brinks_alb.dns_name,
    compose_frontend = file("${path.module}/deploy_temporario/docker-compose-frontend.yml"),
    api_gateway_url  = "${aws_apigatewayv2_api.lambda_api.api_endpoint}/solicitar-relatorio"
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
      api_url = aws_apigatewayv2_stage.lambda_stage.invoke_url,
      db_host = aws_instance.brinks-db.private_ip
      bucket_trusted = aws_s3_bucket.bucket_trusted.bucket,   # usa o nome criado pelo recurso S3
      bucket_client  = aws_s3_bucket.bucket_client.bucket    
    }),
    init_sql_content = file("${path.module}/deploy_temporario/sql/init.sql")
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
      api_url = aws_apigatewayv2_stage.lambda_stage.invoke_url,
      db_host = aws_instance.brinks-db.private_ip
      bucket_trusted = aws_s3_bucket.bucket_trusted.bucket,   # usa o nome criado pelo recurso S3
      bucket_client  = aws_s3_bucket.bucket_client.bucket
    }),
    init_sql_content = file("${path.module}/deploy_temporario/sql/init.sql")
  })

  depends_on = [module.vpc]

  iam_instance_profile = "LabInstanceProfile"

  tags = { Name = "${var.instance_name_pri}-2" }
}

