output "ec2_public_ip" {
  value     = [for instance in aws_instance.ec2 : instance.public_ip]
  sensitive = true
}