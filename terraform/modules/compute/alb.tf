# ALB
resource "aws_lb" "main" {
  name               = "${var.project_name}-alb-${var.environment}"
  internal           = false # for internet
  load_balancer_type = "application"

  security_groups = [var.alb_sg_id]

  # Reachable from the internet
  subnets = var.public_subnet_ids

  tags = {
    Name = "${var.project_name}-alb-${var.environment}"
  }
}

#  Group for routing traffic to the LLM instances
resource "aws_lb_target_group" "app" {
  name     = "${var.project_name}-tg-${var.environment}"
  port     = var.app_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  # STICKY SESSIONS
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400 # for 1 day  in seconds
    enabled         = true
  }

  health_check {
    path                = "/" # OpenWebUI root path
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200" # OK
  }

  tags = {
    Name = "${var.project_name}-tg-${var.environment}"
  }
}

# Listener to accept and forward
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
