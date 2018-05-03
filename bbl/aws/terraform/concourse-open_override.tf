resource "aws_security_group_rule" "concourse_lb_internal_8443" {
  type        = "ingress"
  protocol    = "tcp"
  from_port   = 8443
  to_port     = 8443
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.concourse_lb_internal_security_group.id}"
}

resource "aws_lb_listener" "concourse_lb_8443" {
  load_balancer_arn = "${aws_lb.concourse_lb.arn}"
  protocol          = "TCP"
  port              = 8443

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.concourse_lb_443.arn}"
  }
}
resource "aws_lb_target_group" "concourse_lb_8443" {
  name     = "${var.short_env_id}-uaa8443"
  port     = 8443
  protocol = "TCP"
  vpc_id   = "${local.vpc_id}"
}

output "concourse_domain" {
  value = "${aws_lb.concourse_lb.dns_name}"
}
