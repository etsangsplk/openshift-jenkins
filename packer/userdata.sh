#!/bin/bash
sudo yum update -y
sudo yum install -y wget

# Install java
sudo yum install -y java-1.7.0-openjdk

# Install docker
sudo yum-config-manager \
  --add-repo \
  https://download.docker.com/linux/centos/docker-ce.repo
sudo yum makecache -y fast
sudo yum install -y docker-ce
sudo systemctl enable docker
sudo systemctl start docker

# Manager docker as non-root user
[ $(getent group docker) ] || sudo groupadd docker
sudo usermod -aG docker $USER

# Setup tool for ECR registry authentication
sudo yum install -y unzip
curl -LOk https://github.com/awslabs/amazon-ecr-credential-helper/archive/master.zip
unzip master.zip
cd amazon-ecr-credential-helper-master && sudo make docker
sudo cp bin/local/docker-credential-ecr-login /usr/bin
mkdir ~/.docker
echo "{\"credsStore\":\"ecr-login\"}" > ~/.docker/config.json

# Create directory for Jenkins data
JENKINS_DIR=/var/jenkins
sudo mkdir -p $JENKINS_DIR
sudo chown -R $USER $JENKINS_DIR
