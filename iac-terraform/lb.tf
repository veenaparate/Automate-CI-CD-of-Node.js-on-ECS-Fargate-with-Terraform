resource "aws_lb" "lb" {
  name            = "node-lb"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]
}

resource "aws_lb_target_group" "target_group" {
  name        = "node-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.default.id
  target_type = "ip"
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.lb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.target_group.id
    type             = "forward"
  }
}