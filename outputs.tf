output "instance_public_ip_pub_1" {
  description = "IP Público da instância EC2 (pub-1)"
  value       = aws_instance.brinks-pub-1.public_ip
}


output "instance_hostname_pri_1" {
  description = "DNS Privado da instância EC2 (pri-1)"
  value       = aws_instance.brinks-pri-1.private_dns
}

output "instance_hostname_pri_2" {
  description = "DNS Privado da instância EC2 (pri-2)"
  value       = aws_instance.brinks-pri-2.private_dns
}

output "load_balancer_dns" {
  description = "DNS público do Load Balancer para acessar o Backend"
  value       = aws_lb.brinks_alb.dns_name
}