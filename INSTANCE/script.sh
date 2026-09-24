#!/bin/bash
# Update and install Docker
sudo apt update -y
sudo apt install -y docker.io

# Start Docker and enable it
sudo systemctl start docker
sudo systemctl enable docker

# Pull Jenkins LTS Docker image
sudo docker pull jenkins/jenkins:lts

# Run Jenkins container
sudo docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts
