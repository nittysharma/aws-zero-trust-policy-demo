#!/bin/bash

PROJECT_NAME="zero-trust-demo"
REGION="us-east-1"

echo "🚀 Deploying Zero Trust Demo Platform..."

# Deploy base infrastructure
echo "📦 Deploying base infrastructure..."
aws cloudformation deploy \
  --template-file base-infrastructure.yml \
  --stack-name ${PROJECT_NAME}-base \
  --parameter-overrides ProjectName=${PROJECT_NAME} \
  --capabilities CAPABILITY_NAMED_IAM \
  --region ${REGION}

if [ $? -eq 0 ]; then
  echo "✅ Base infrastructure deployed successfully"
else
  echo "❌ Base infrastructure deployment failed"
  exit 1
fi

# Deploy services
echo "🔧 Deploying services..."
aws cloudformation deploy \
  --template-file service-config.yml \
  --stack-name ${PROJECT_NAME}-services \
  --parameter-overrides ProjectName=${PROJECT_NAME} \
  --capabilities CAPABILITY_IAM \
  --region ${REGION}

if [ $? -eq 0 ]; then
  echo "✅ Services deployed successfully"
else
  echo "❌ Services deployment failed"
  exit 1
fi

echo "🎯 Demo platform deployed successfully!"
echo "📋 Next steps:"
echo "  1. Configure IAM Roles Anywhere trust anchor"
echo "  2. Set up contractor certificates"
echo "  3. Test access through Verified Access endpoint"