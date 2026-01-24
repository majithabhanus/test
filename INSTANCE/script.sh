#!/bin/bash
set -eux

apt-get update -y
apt-get install -y openjdk-21-jdk curl gnupg git

# Add new key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Add repo using the new key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list

apt-get update -y
apt-get install -y jenkins

systemctl enable jenkins
systemctl start jenkins
