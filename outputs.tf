output "site-domain-name" {
  value = aws_instance.web-worker.public_dns
}
output "db-ext-address" {
  value = aws_instance.mysql-server.public_ip
}