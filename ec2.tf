resource "aws_instance" "brinks-pub-1" {
  ami                         = var.ami_ubuntu
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.pub_sg.id]
  associate_public_ip_address = true
  key_name = var.instance_key

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
  key_name = var.instance_key

  tags = {
    Name = "${var.instance_name_pub}-2"
  }
}

resource "aws_instance" "brinks-pri-1" {
  ami                         = var.ami_ubuntu
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids      = [aws_security_group.pri_sg.id]
  key_name = var.instance_key

  tags = {
    Name = "${var.instance_name_pri}-1"
  }
}

resource "aws_instance" "brinks-pri-2" {
  ami                         = var.ami_ubuntu
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.private_subnets[1]
  vpc_security_group_ids      = [aws_security_group.pri_sg.id]
  key_name = var.instance_key

  tags = {
    Name = "${var.instance_name_pri}-2"
  }
}