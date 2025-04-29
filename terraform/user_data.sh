#!/bin/bash
sudo -i
# Update packages
yum update -y

# Enable docker from amazon-linux-extras and install
amazon-linux-extras enable docker
yum install -y docker

# Start and enable docker service
systemctl start docker
systemctl enable docker

# Add default ec2-user to docker group
usermod -aG docker ec2-user

# Login to Docker Hub (optional – requires credentials set up)
# echo "<DOCKER_PASSWORD>" | docker login -u "<DOCKER_USERNAME>" --password-stdin

# Pull and run your Docker image
sudo docker pull jagadhee/adminstrapi
sudo docker run -d -p 1500:1337 -e HOST=0.0.0.0 jagadhee/adminstrapi