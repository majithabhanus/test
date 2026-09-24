# -------------------------
# PROVIDERS
# -------------------------

provider "aws" {
  alias  = "mumbai"
  region = "ap-south-1"
}

provider "aws" {
  alias  = "singapore"
  region = "ap-southeast-1"
}


# =========================
# MUMBAI - PRIMARY
# =========================

resource "aws_vpc" "mumbai" {
  provider   = aws.mumbai
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "mumbai-vpc"
  }
}

resource "aws_subnet" "mumbai" {
  provider          = aws.mumbai
  vpc_id            = aws_vpc.mumbai.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  map_public_ip_on_launch = true

  tags = {
    Name = "mumbai-subnet"
  }
}

resource "aws_internet_gateway" "mumbai" {
  provider = aws.mumbai
  vpc_id   = aws_vpc.mumbai.id

  tags = {
    Name = "mumbai-igw"
  }
}

resource "aws_route_table" "mumbai" {
  provider = aws.mumbai
  vpc_id   = aws_vpc.mumbai.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mumbai.id
  }

  tags = {
    Name = "mumbai-route-table"
  }
}

resource "aws_route_table_association" "mumbai" {
  provider = aws.mumbai

  subnet_id      = aws_subnet.mumbai.id
  route_table_id = aws_route_table.mumbai.id
}

resource "aws_security_group" "mumbai" {
  provider = aws.mumbai

  name   = "mumbai-ec2-sg"
  vpc_id = aws_vpc.mumbai.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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

resource "aws_instance" "mumbai" {
  provider = aws.mumbai

  ami           = "ami-01a00762f46d584a1"
  instance_type = "t3.micro"

  subnet_id = aws_subnet.mumbai.id

  vpc_security_group_ids = [
    aws_security_group.mumbai.id
  ]

  key_name = "new"

  tags = {
    Name = "mumbai-primary"
  }
}


# =========================
# SINGAPORE - DR
# =========================

resource "aws_vpc" "singapore" {
  provider   = aws.singapore
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "singapore-vpc"
  }
}

resource "aws_subnet" "singapore" {
  provider          = aws.singapore
  vpc_id            = aws_vpc.singapore.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "ap-southeast-1a"

  map_public_ip_on_launch = true

  tags = {
    Name = "singapore-subnet"
  }
}

resource "aws_internet_gateway" "singapore" {
  provider = aws.singapore
  vpc_id   = aws_vpc.singapore.id

  tags = {
    Name = "singapore-igw"
  }
}

resource "aws_route_table" "singapore" {
  provider = aws.singapore
  vpc_id   = aws_vpc.singapore.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.singapore.id
  }

  tags = {
    Name = "singapore-route-table"
  }
}

resource "aws_route_table_association" "singapore" {
  provider = aws.singapore

  subnet_id      = aws_subnet.singapore.id
  route_table_id = aws_route_table.singapore.id
}

resource "aws_security_group" "singapore" {
  provider = aws.singapore

  name   = "singapore-ec2-sg"
  vpc_id = aws_vpc.singapore.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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

locals {
  primary_instance_type = "t3.medium"
  dr_instance_type      = "t3.small"
}

resource "aws_instance" "singapore" {
  provider = aws.singapore

  ami           = "ami-0532913178263be11"
  instance_type = "t3.micro"

  subnet_id = aws_subnet.singapore.id

  vpc_security_group_ids = [
    aws_security_group.singapore.id
  ]

  key_name = "new"

  tags = {
    Name = "singapore-dr"
  }
}


# =========================
# OUTPUTS
# =========================

output "mumbai_public_ip" {
  value = aws_instance.mumbai.public_ip
}

output "singapore_public_ip" {
  value = aws_instance.singapore.public_ip
}