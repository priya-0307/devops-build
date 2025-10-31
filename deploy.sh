#!/bin/bash
set -e

EC2_USER="ubuntu"
EC2_HOST="13.233.19.14"
KEY_PATH="/home/ubuntu/key-pair-1.pem"
DOCKERHUB_USER="priyadharshini030722"


PROD_REPO="$DOCKERHUB_USER/devops-build-prod"
TAG="latest"

REMOTE_COMMANDS=$(cat << EOF
  echo " Pulling latest image..."
  docker pull $PROD_REPO:$TAG

  echo "Stopping and removing old container..."
  docker stop react-app || true
  docker rm react-app || true

  echo " Running new container on port 80..."
  docker run -d -p 80:80 --name react-app $PROD_REPO:$TAG

  echo "Deployed successfully on port 80!"
EOF
)

echo " Deploying to EC2: $EC2_HOST"
ssh -i $KEY_PATH -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST "$REMOTE_COMMANDS"
