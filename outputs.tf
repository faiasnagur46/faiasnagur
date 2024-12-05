
output "ansible_master_public_ip" {
  value = aws_instance.ansible_master.public_ip
}

output "ansible_slave_public_ips" {
  value = [for instance in aws_instance.ansible_slave : instance.public_ip]
}
