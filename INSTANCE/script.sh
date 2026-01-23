#!/bin/bash
  
  set -eux
exec > /var/log/user-data.log 2>&1

# Wait for cloud-init to finish
while [ ! -f /var/lib/cloud/instance/boot-finished ]; do
  sleep 2
done

apt update -y
apt install -y openjdk-17-jre curl gnupg

# Jenkins key
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key \
  | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Jenkins repo
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian binary/" \
  | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

apt update -y
apt install -y jenkins

systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins
