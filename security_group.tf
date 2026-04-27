resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Permite HTTP externo para o ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port        = var.porta_http
    to_port          = var.porta_http
    protocol         = "tcp"
    cidr_blocks      = var.ips_qualquer_lugar_v4
    ipv6_cidr_blocks = var.ips_qualquer_lugar_v6
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = var.ips_qualquer_lugar_v4
    ipv6_cidr_blocks = var.ips_qualquer_lugar_v6
  }
}

resource "aws_security_group" "pub_sg" {
  name        = "pub-sg"
  description = "Permite SSH e HTTP externos"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port        = var.porta_ssh
    to_port          = var.porta_ssh
    protocol         = "tcp"
    cidr_blocks      = var.ips_qualquer_lugar_v4
    ipv6_cidr_blocks = var.ips_qualquer_lugar_v6
  }
  ingress {
    from_port        = var.porta_http
    to_port          = var.porta_http
    protocol         = "tcp"
    cidr_blocks      = var.ips_qualquer_lugar_v4
    ipv6_cidr_blocks = var.ips_qualquer_lugar_v6
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = var.ips_qualquer_lugar_v4
    ipv6_cidr_blocks = var.ips_qualquer_lugar_v6
  }
}

resource "aws_security_group" "pri_sg" {
  name        = "pri-sg"
  description = "Permite ALB (Backend), SSH (Bastion) e MySQL (Interno)"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port       = var.porta_http
    to_port         = var.porta_http
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port       = var.porta_ssh
    to_port         = var.porta_ssh
    protocol        = "tcp"
    security_groups = [aws_security_group.pub_sg.id]
  }

  ingress {
    from_port   = var.porta_mysql
    to_port     = var.porta_mysql
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Permite MySQL e RabbitMQ vindos do Backend"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.pub_sg.id]
  }

  # MySQL
  ingress {
    from_port       = var.porta_mysql
    to_port         = var.porta_mysql
    protocol        = "tcp"
    security_groups = [aws_security_group.pri_sg.id]
  }

  # RabbitMQ
  ingress {
    from_port       = 5672
    to_port         = 5672
    protocol        = "tcp"
    security_groups = [aws_security_group.pri_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_iam_role" "lab_role" {
  name = "LabRole"
}
