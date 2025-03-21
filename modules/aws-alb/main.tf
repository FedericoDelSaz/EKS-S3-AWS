resource "aws_security_group" "alb_security_group" {
  vpc_id = var.vpc_id
  name   = var.vpc_name
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_lb" "new_work_alb" {
  name               = "new-work-se-test-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]
  subnets            = var.public_subnets

  enable_deletion_protection = false
  tags = {
    Name = "new-work-se-test-alb"
  }
}

resource "aws_lb_target_group" "new_work_tg" {
  name     = "new-work-se-test-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.new_work_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.new_work_tg.arn
  }
}
