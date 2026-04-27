resource "aws_lb" "brinks_alb" {
  name               = "brinks-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_target_group" "brinks_tg" {
  name     = "brinks-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/health"
    port                = "8080"
    matcher             = "200-399"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.brinks_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.brinks_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "pri1" {
  target_group_arn = aws_lb_target_group.brinks_tg.arn
  target_id        = aws_instance.brinks-pri-1.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "pri2" {
  target_group_arn = aws_lb_target_group.brinks_tg.arn
  target_id        = aws_instance.brinks-pri-2.id
  port             = 8080
}