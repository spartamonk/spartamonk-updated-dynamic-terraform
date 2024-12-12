data "aws_ami" "ami" {
  most_recent = true
  owners      = ["137112412989"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20241113.1-x86_64-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  user_data = <<-EOT
              #!/bin/bash
              yum update -y
              amazon-linux-extras enable nginx1
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Welcome to NGINX on Amazon Linux</h1>" > /usr/share/nginx/html/index.html
              EOT
}
resource "aws_instance" "instance" {
  for_each                    = var.instance
  ami                         = data.aws_ami.ami.id
  instance_type               = each.value.instance_type
  associate_public_ip_address = each.value.associate_public_ip
  subnet_id                   = each.value.associate_public_ip == true ? var.public_subnet_id : var.private_subnet_id
  security_groups             = each.value.associate_public_ip == true ? [aws_security_group.bastion_sg.id] : [aws_security_group.webserver_sg.id]
  key_name                    = each.value.key_name
  user_data                   = each.value.associate_public_ip == false ? local.user_data : null
  tags = {
    Name = each.key
  }
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "Allow TLS inbound ssh traffic and all outbound traffic"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = var.bastion_sg
    content {
      cidr_blocks = ["0.0.0.0/0"]
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "bastion_sg"
  }
}

resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "Allow TLS inbound ssh traffic and all outbound traffic"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = var.webserver_sg
    content {
      description     = ingress.value.description
      from_port       = ingress.value.port
      to_port         = ingress.value.port
      protocol        = "tcp"
      cidr_blocks     = []
      security_groups = [aws_security_group.bastion_sg.id]
    }
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = []
    security_groups = [aws_security_group.bastion_sg.id]
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "webserver_sg"
  }
}
