resource "aws_route53_record" "r53" {
  zone_id = "Z0537173201HISIGMS6CD"
  name    = "vinga.tk"
  type    = "A"
  alias {
    name                   = "${aws_elb.myelb.dns_name}"
    zone_id                = "${aws_elb.myelb.zone_id}"
    evaluate_target_health = "true"
  }
}
