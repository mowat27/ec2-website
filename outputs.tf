output "web_servers" {
  value = zipmap( 
    aws_instance.web_server.*.public_ip, 
    [for server in aws_instance.web_server.* : format("http://%s", server.public_dns)] 
  )
}

output "compute_server_private_ip" {
  value = aws_instance.compute_server.private_ip
}