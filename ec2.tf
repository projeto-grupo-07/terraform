resource "aws_instance" "brinks-db" {
  ami                    = var.ami_ubuntu
  instance_type          = var.instance_type
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  key_name               = var.instance_key

  user_data = templatefile("${path.module}/deploy_temporario/database.sh.tftpl", {
    init_sql_content = file("${path.module}/deploy_temporario/init.sql")
  })

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
    alb_dns = aws_lb.brinks_alb.dns_name
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

  # Injeta o IP privado da instância de banco no script
  user_data = templatefile("${path.module}/deploy_temporario/backend.sh.tftpl", {
    db_host = aws_instance.brinks-db.private_ip
  })

  tags = { Name = "${var.instance_name_pri}-1" }
}

resource "aws_instance" "brinks-pri-2" {
  ami                    = var.ami_ubuntu
  instance_type          = var.instance_type
  subnet_id              = module.vpc.private_subnets[1]
  vpc_security_group_ids = [aws_security_group.pri_sg.id]
  key_name               = var.instance_key

  user_data = templatefile("${path.module}/deploy_temporario/backend.sh.tftpl", {
    db_host = aws_instance.brinks-db.private_ip
  })

  tags = { Name = "${var.instance_name_pri}-2" }
}