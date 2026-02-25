output "instance_id" {
  value = aws_instance.web_server.id
}

output "public_ip" {
  value = aws_eip.web_eip.public_ip
}

output "public_dns" {
  value = aws_instance.web_server.public_dns
}