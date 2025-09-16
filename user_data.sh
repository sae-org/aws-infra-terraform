#!/bin/bash
set -e

# Update and install prerequisites
apt-get update -y
apt-get install -y docker.io unzip curl

# Ensure Docker starts on boot
systemctl enable docker
systemctl start docker

# Install AWS CLI v2 if missing
if ! command -v aws >/dev/null 2>&1; then
  curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
  unzip -q /tmp/awscliv2.zip -d /tmp
  /tmp/aws/install --update
fi