data "aws_route53_zone" "main" {
  name         = "i-am-terraform-specialist.tk"
  private_zone = false
}

resource "aws_route53_record" "main" {
  type = "A"
  name    = "i-am-terraform-specialist.tk"  // 取得したドメイン
  zone_id = data.aws_route53_zone.main.id

  alias {
    name                   = aws_lb.for_webserver.dns_name
    zone_id                = aws_lb.for_webserver.zone_id
    evaluate_target_health = true
  }
}
