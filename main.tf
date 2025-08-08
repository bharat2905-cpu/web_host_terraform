provider "aws" {
    access_key = "**********"         # IAM USER ACCESS_KEY
    secret_key = "*****************"  # IAM USER SECRET_KEY
    region = var.aws_region
}

# Security Group to allow SSH and HTTP
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # SSH
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HTTP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
 
# EC2 instance
resource "aws_instance" "web" {
  ami                    = "ami-0f918f7e67a3323f0"  # data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = "terra"    # Key Name .pem
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y apache2
              systemctl start apache2
              systemctl enable apache2
              echo "${file("index.html")}" > /var/www/html/index.html
              EOF

  tags = {
    Name = "StaticWebsiteEC2"
  }
}