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

# add vault port for jumpbox
resource "aws_security_group_rule" "bosh_security_group_rule_vault" {
  security_group_id        = "${aws_security_group.bosh_security_group.id}"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8200
  to_port                  = 8200
  source_security_group_id = "${aws_security_group.jumpbox.id}"
}
