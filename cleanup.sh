#!/bin/bash

echo "🧹 Cleaning up Zero Trust Demo resources..."

# Delete services stack first
echo "🗑️  Deleting services stack..."
aws cloudformation delete-stack --stack-name zero-trust-demo-services

# Wait for services stack to delete
echo "⏳ Waiting for services stack deletion..."
aws cloudformation wait stack-delete-complete --stack-name zero-trust-demo-services

# Delete base infrastructure stack
echo "🗑️  Deleting base infrastructure stack..."
aws cloudformation delete-stack --stack-name zero-trust-demo-base

# Wait for base stack to delete
echo "⏳ Waiting for base stack deletion..."
aws cloudformation wait stack-delete-complete --stack-name zero-trust-demo-base

echo "✅ Cleanup completed!"