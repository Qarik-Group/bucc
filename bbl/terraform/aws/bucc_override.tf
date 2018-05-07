# open port 8443 for uaa authentication
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
    target_group_arn = "${aws_lb_target_group.concourse_lb_8443.arn}"
  }
}

resource "aws_lb_target_group" "concourse_lb_8443" {
  name     = "${var.short_env_id}-concourse8443"
  port     = 8443
  protocol = "TCP"
  vpc_id   = "${local.vpc_id}"
}

# vars needed for bucc flags (which are included via common.sh)
output "director__security_groups" {
  value = [
    "${aws_security_group.bosh_security_group.id}",
    "${aws_security_group.concourse_lb_internal_security_group.name}",
    "${aws_security_group.internal_security_group.id}",
 ]
}

output "director__lb_target_groups" {
  value = [
    "${aws_lb_target_group.concourse_lb_80.name}",
    "${aws_lb_target_group.concourse_lb_443.name}",
    "${aws_lb_target_group.concourse_lb_2222.name}",
    "${aws_lb_target_group.concourse_lb_8443.name}",
 ]
}

output "director__concourse_domain" {
  value = "${aws_lb.concourse_lb.dns_name}"
}
