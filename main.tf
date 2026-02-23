provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "brinks-vpc"
  cidr = "10.0.0.0/25"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.0.0/27", "10.0.0.32/27"]  
  private_subnets = ["10.0.0.64/27", "10.0.0.96/27"] 

  create_igw           = true
  enable_nat_gateway   = false
  enable_dns_hostnames = true
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Permite HTTP externo para o ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "pub_sg" {
  name        = "pub-sg"
  description = "Permite SSH e HTTP externos"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "pri_sg" {
  name        = "pri-sg"
  description = "Permite ALB (Backend), SSH (Bastion) e MySQL (Interno)"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.pub_sg.id]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
}

resource "aws_lb" "brinks_alb" {
  name               = "brinks-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_target_group" "brinks_tg" {
  name     = "brinks-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.brinks_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.brinks_tg.arn
  }
}

resource "aws_instance" "brinks-pub-1" {
  ami                         = var.ami_ubuntu
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.pub_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.instance_name_pub}-1"
  }
}

resource "aws_instance" "brinks-pub-2" {
  ami                         = var.ami_ubuntu
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[1]
  vpc_security_group_ids      = [aws_security_group.pub_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.instance_name_pub}-2"
  }
}

resource "aws_instance" "brinks-pri-1" {
  ami                         = var.ami_ubuntu
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids      = [aws_security_group.pri_sg.id]

  tags = {
    Name = "${var.instance_name_pri}-1"
  }
}

resource "aws_instance" "brinks-pri-2" {
  ami                         = var.ami_ubuntu
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.private_subnets[1]
  vpc_security_group_ids      = [aws_security_group.pri_sg.id]

  tags = {
    Name = "${var.instance_name_pri}-2"
  }
}

resource "aws_lb_target_group_attachment" "pri1" {
  target_group_arn = aws_lb_target_group.brinks_tg.arn
  target_id        = aws_instance.brinks-pri-1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "pri2" {
  target_group_arn = aws_lb_target_group.brinks_tg.arn
  target_id        = aws_instance.brinks-pri-2.id
  port             = 80
}

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
  