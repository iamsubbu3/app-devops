#!/bin/bash

EC2_USER="ubuntu"            
EC2_HOST="100.25.216.214"    
KEY="/home/iamsubbu/Downloads/iamsubbu-keypair.pem"      

ssh -i $KEY $EC2_USER@$EC2_HOST << EOF
  # Update system and install required packages
  sudo apt update -y
  sudo apt install -y git docker.io

  # Start Docker service and enable on boot
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -aG docker ubuntu

  # Pull or update your repository
  if [ ! -d "app-devops" ]; then
      git clone https://github.com/iamsubbu3/app-devops.git
  else
      cd Flask_app && git pull
  fi

  # Navigate to project and build Docker image
  cd Flask_app
  docker build -t flask-app .

  # Stop and remove old container if exists
  docker stop flask-app || true
  docker rm flask-app || true

  # Run new container on port 80 -> 5000
  docker run -d -p 80:5000 --name flask-app flask-app:latest
EOF
