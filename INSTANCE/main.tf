# Security group for Jenkins
resource "aws_security_group" "jenkins_sg" {
  name        = "Jenkins-SG"
  description = "Allow Jenkins and SSH traffic"

  ingress = [
    for port in [22, 8080] : {
      description = "Open port ${port}"
      from_port   = port
      to_port     = port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-SG"
  }
}

# EC2 instance
resource "aws_instance" "jenkins" {
  ami                    = "ami-0b6c6ebed2801a5cb" # Ubuntu 24 AMI
  instance_type          = "t2.medium"
  key_name               = "rrr"                    # Replace with your key
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  user_data              = file("${path.module}/script.sh")

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name = "Jenkins-Server"
  }
}
