resource "aws_lb" "brinks_alb" {
  name               = "brinks-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_target_group" "brinks_tg" {
  name     = "brinks-tg"
  port     = var.porta_http
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.brinks_alb.arn
  port              = var.porta_http
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.brinks_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "pri1" {
  target_group_arn = aws_lb_target_group.brinks_tg.arn
  target_id        = aws_instance.brinks-pri-1.id
  port             = var.porta_http
}

resource "aws_lb_target_group_attachment" "pri2" {
  target_group_arn = aws_lb_target_group.brinks_tg.arn
  target_id        = aws_instance.brinks-pri-2.id
  port             = var.porta_http
}