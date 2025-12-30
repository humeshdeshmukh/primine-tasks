#!/bin/bash

APP_NAME=$1
IMAGE_TAG=$2

echo "--------------------------------------------------"
echo "Starting Blue-Green Deployment Simulation for $APP_NAME:$IMAGE_TAG"
echo "--------------------------------------------------"

echo "[1/4] Identifying current active target group (Blue)..."
sleep 1
CURRENT_COLOR="blue"
NEW_COLOR="green"
echo "Current active: $CURRENT_COLOR"

echo "[2/4] Deploying new task definition to $NEW_COLOR target group..."
sleep 2
echo "Task registered: arn:aws:ecs:us-east-1:123456789012:task-definition/$APP_NAME:$IMAGE_TAG"
echo "Service updating..."

echo "[3/4] Running health checks on $NEW_COLOR..."
sleep 2
echo "Health check passed: HTTP 200 OK"

echo "[4/4] Switching traffic listener to $NEW_COLOR..."
sleep 1
echo "Traffic rerouted. Old tasks draining."

echo "--------------------------------------------------"
echo "Deployment Successful! Active: $NEW_COLOR"
echo "--------------------------------------------------"
