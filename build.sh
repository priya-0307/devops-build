#!/bin/bash
set -e

DOCKERHUB_USER="your-dockerhub-username"
DEV_REPO="$DOCKERHUB_USER/devops-build-dev"
PROD_REPO="$DOCKERHUB_USER/devops-build-prod"
BRANCH=$(git rev-parse --abbrev-ref HEAD)
IMAGE_TAG=$(git rev-parse --short HEAD)

if [ "$BRANCH" == "dev" ]; then
    REPO=$DEV_REPO
elif [ "$BRANCH" == "main" ]; then
    REPO=$PROD_REPO
else
    echo " Unknown branch: $BRANCH. Only 'dev' and 'main' are supported."
    exit 1
fi

FULL_IMAGE="$REPO:$IMAGE_TAG"
LATEST_TAG="$REPO:latest"

echo "Building image for branch: $BRANCH"
docker build -t $FULL_IMAGE .
docker tag $FULL_IMAGE $LATEST_TAG

echo " Logging into DockerHub..."
docker login -u "$DOCKERHUB_USER"

echo " Pushing image to $REPO..."
docker push $FULL_IMAGE
docker push $LATEST_TAG

echo "Build & push complete! Image: $FULL_IMAGE"
