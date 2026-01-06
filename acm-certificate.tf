resource "aws_acm_certificate" "lzb-cert" {
  domain_name               = "wallawalla.co.za"
  subject_alternative_names = ["www.wallawalla.co.za"]
  validation_method         = "DNS"
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.lzb-cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = var.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "lzb-certificate" {
  certificate_arn         = aws_acm_certificate.lzb-cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

/*
resource "aws_route53_record" "cert_validation" {
  name    = tolist(aws_acm_certificate.lzb-cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.lzb-cert.domain_validation_options)[0].resource_record_type
  zone_id = var.zone_id
  records = [tolist(aws_acm_certificate.lzb-cert.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "lzb-certificate" {
  certificate_arn         = aws_acm_certificate.lzb-cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}*/