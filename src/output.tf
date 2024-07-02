output "instance_public_dns" {
    value = aws_instance.grafana_instance.public_dns
}