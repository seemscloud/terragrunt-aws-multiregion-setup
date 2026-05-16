output "association_ids" {
  value = { for k, association in aws_route53_zone_association.this : k => association.id }
}
