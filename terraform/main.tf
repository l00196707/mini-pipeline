provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "app_sg"{
    name = "app_sg"
    description = "Allow HTTP"
    vpc_id = "vpc-0d82d571d6631d13c"

    ingress {
        from_port = 5000
        to_port = 5000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
variable "docker_username" {
    description = "DockerHub username"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0cae6d6fe6048ca2c"
  instance_type = "t2.micro"
  key_name      = "ec2-key"
  security_groups = [aws_security_group.app_sg.name]

  user_data = <<EOF
#!/bin/bash
set -ex

# Update system
dnf update -y

# Install Docker
dnf install -y docker

# Enable & start Docker
systemctl enable docker
systemctl start docker

# Add ec2-user to run docker
usermod -aG docker ec2-user
docker pull ${var.docker_username}/mini-pipeline:latest
docker run -d -p 5000:5000 ${var.docker_username}/mini-pipeline:latest
EOF

}

output "public_ip" {
  value = aws_instance.app_server.public_ip
}