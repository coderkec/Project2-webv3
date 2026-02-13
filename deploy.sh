#!/bin/bash

# Configuration
PROJECT_DIR="/root/web-v2"
IMAGE_NAME="dashboard"
IMAGE_TAG="latest" 
HARBOR_URL="10.2.2.40:5000/library/web-v2-dashboard"
DEPLOYMENT_NAME="web-v2-dashboard"
NAMESPACE="team2"  # 네임스페이스 변수 추가

# Ensure we are in the project directory
cd $PROJECT_DIR || { echo "Directory not found: $PROJECT_DIR"; exit 1; }

echo "Step 1: Code status check..."
git status

echo "Step 2: Building Docker image..."
docker build --no-cache -t $IMAGE_NAME:$IMAGE_TAG .

echo "Step 3: Tagging and Pushing to Harbor..."
docker tag $IMAGE_NAME:$IMAGE_TAG $HARBOR_URL:$IMAGE_TAG
docker push $HARBOR_URL:$IMAGE_TAG

echo "Step 4: Updating Kubernetes Deployment in namespace: $NAMESPACE..."
# 여기에 -n $NAMESPACE가 꼭 들어가야 합니다!
kubectl set image deployment/$DEPLOYMENT_NAME $DEPLOYMENT_NAME=$HARBOR_URL:$IMAGE_TAG -n $NAMESPACE

echo "Step 5: Restarting Deployment to ensure fresh pods..."
kubectl rollout restart deployment/$DEPLOYMENT_NAME -n $NAMESPACE
kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE

echo "Deployment Complete in Team2 Namespace!"

