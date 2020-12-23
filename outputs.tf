output "web_server_public_ip" {
  value = aws_instance.web_server.public_ip
}

output "web_server_public_dns" {
  value = "http://${aws_instance.web_server.public_dns}"
}

output "compute_server_private_ip" {
  value = aws_instance.compute_server.private_ip
}