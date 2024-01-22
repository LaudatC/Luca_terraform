aws_access_key = "your_access_key"
aws_secret_key = "your_secret_key"

provider "aws" {
  region = "eu-central-1" # Change to your AWS region
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = "vpc-0c95d6e9d241d501a"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0292a7daeeda6b851" # Change to the latest AMI in your region
  instance_type = "t2.micro" # Change as needed
  subnet_id     = "subnet-0e75e328d821f006f"
  security_groups = [aws_security_group.allow_http.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "Hello Luca from 2024!" > /var/www/html/index.html
              EOF

  tags = {
    Name = "Apache Web Server"
  }
}
