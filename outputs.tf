output "instance_public_ip" {
  value = aws_instance.web.public_ip        # public_ip
}

output "website_url" {
  value = "http://${aws_instance.web.public_ip}"        # URL public_ip
}