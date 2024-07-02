resource "aws_instance" "grafana_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type =  "t3.micro"
  vpc_security_group_ids      = [aws_security_group.app_grafana_instance_sg.id]
  associate_public_ip_address = true
  key_name = "vockey"
  user_data = file("init_script.sh")
  iam_instance_profile = "LabInstanceProfile"
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }
  tags = {
    Name = "grafana_instance"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] /* Ubuntu Canonical owner*/

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_security_group" "app_grafana_instance_sg" {
  name        = "grafana_instance"
  description = "Grafana Instance security group"
  ingress {
    description      = "HTTP from Anywhere to Grafana"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  } 
}
