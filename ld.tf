resource "aws_alb_target_group" "jenkins_alb_tg" {
  name        = "jenkins-alb-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.main_vpc.id
  health_check {
    port                = 8080
    protocol            = "HTTP"
    interval            = 30
    path                = "/login"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = 200
  }
}

resource "aws_alb_target_group_attachment" "alb_tg_at" {
  target_group_arn = aws_alb_target_group.jenkins_alb_tg.arn
  target_id        = aws_instance.jenkins.id
  port             = 8080
}


resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.jenkins_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.jenkins_alb_tg.arn
    type             = "forward"
  }
}

resource "aws_alb" "jenkins_alb" {
  name               = "jenkins-alb"
  subnets            = [aws_subnet.vlan1.id, aws_subnet.vlan2.id]
  security_groups    = [aws_security_group.alb_sg.id]
  internal           = false
  load_balancer_type = "application"
  access_logs {
    bucket = "a-khalilau-terraform"
    prefix = "logs"
  }
}