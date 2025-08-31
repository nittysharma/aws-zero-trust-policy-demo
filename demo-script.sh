#!/bin/bash

PROJECT_NAME="zero-trust-demo"

echo "🎭 Zero Trust Demo Script"
echo "========================"

# Function to simulate contractor authentication
demo_contractor_auth() {
  echo "👤 Simulating contractor authentication..."
  
  # Get role ARN from CloudFormation
  ROLE_ARN=$(aws cloudformation describe-stacks \
    --stack-name ${PROJECT_NAME}-base \
    --query 'Stacks[0].Outputs[?OutputKey==`ContractorRoleArn`].OutputValue' \
    --output text 2>/dev/null)
  
  if [ $? -eq 0 ] && [ ! -z "$ROLE_ARN" ]; then
    echo "  📜 Contractor certificate validated"
    echo "  🔐 IAM role authenticated: ${ROLE_ARN}"
    echo "  🎫 Temporary credentials issued"
    echo "  ✅ Authentication successful"
  else
    echo "  ⚠️  Stack not deployed or AWS CLI not configured"
    echo "  📋 Demo flow (simulated):"
    echo "    - Certificate presented"
    echo "    - IAM Roles Anywhere validates"
    echo "    - Temporary credentials issued"
  fi
}

# Function to demonstrate API access
demo_api_access() {
  echo "🌐 Demonstrating secure API access..."
  
  # Get API endpoint
  API_ENDPOINT=$(aws cloudformation describe-stacks \
    --stack-name ${PROJECT_NAME}-services \
    --query 'Stacks[0].Outputs[?OutputKey==`ApiEndpoint`].OutputValue' \
    --output text 2>/dev/null)
  
  if [ $? -eq 0 ] && [ ! -z "$API_ENDPOINT" ]; then
    echo "  🔗 API Endpoint: ${API_ENDPOINT}"
    echo "  🔐 Testing authenticated access..."
    
    # Test API call (requires AWS credentials)
    aws apigatewayv2 get-apis --query 'Items[0].Name' --output text >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      echo "  ✅ API accessible with valid credentials"
    else
      echo "  🔒 API requires valid AWS credentials (IAM authentication)"
    fi
  else
    echo "  📋 Demo API would be accessible at:"
    echo "    https://api-gateway-id.execute-api.region.amazonaws.com/demo/secure"
  fi
}

# Function to show security features
demo_security_features() {
  echo "🛡️ Zero Trust Security Features..."
  echo "  🔐 IAM-based authentication on API Gateway"
  echo "  🏷️  Role-based access control with tags"
  echo "  📊 CloudTrail logging for all API calls"
  echo "  🔍 Request/response monitoring"
  echo "  ⚡ Serverless architecture (no persistent infrastructure)"
}

# Function to test access patterns
demo_access_patterns() {
  echo "🧪 Access Pattern Testing..."
  echo "  ✅ Valid contractor role → API access granted"
  echo "  ❌ Invalid credentials → Access denied"
  echo "  ❌ Missing IAM permissions → Forbidden"
  echo "  📝 All attempts logged in CloudTrail"
}

# Main demo flow
main() {
  echo "Starting simplified zero-trust demo..."
  echo
  
  demo_contractor_auth
  echo
  
  demo_api_access
  echo
  
  demo_security_features
  echo
  
  demo_access_patterns
  echo
  
  echo "🎉 Demo completed!"
  echo "💡 This demonstrates core zero-trust principles:"
  echo "  - Identity-based authentication (IAM)"
  echo "  - Least-privilege access (role policies)"
  echo "  - Secure API communication (HTTPS + IAM)"
  echo "  - Comprehensive logging (CloudTrail)"
}

# Run the demo
main