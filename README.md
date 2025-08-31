# Zero Trust Demo Platform

A minimal implementation demonstrating secure application access using AWS services.

## Architecture

- **IAM Roles**: Certificate-based authentication for contractors
- **API Gateway**: Secure API access with IAM authentication
- **Lambda**: Serverless backend services
- **VPC Lattice**: Service network (where supported)
- **Verified Access**: Context-aware access control (where supported)

## Prerequisites

- AWS CLI configured with valid credentials
- Python 3.x with boto3 installed
- Appropriate AWS permissions for CloudFormation, IAM, Lambda, API Gateway

## Quick Start

1. **Configure AWS Credentials**
   ```bash
   aws configure
   # OR
   export AWS_ACCESS_KEY_ID=your-key
   export AWS_SECRET_ACCESS_KEY=your-secret
   ```

2. **Deploy Infrastructure**
   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```

3. **Run Demo**
   ```bash
   # Command line demo
   ./demo-script.sh
   
   # Interactive web demo with AWS integration
   python3 -m venv venv
   source venv/bin/activate
   pip install boto3
   python3 backend.py
   ```

## Components

- `base-infrastructure.yml` - VPC, IAM roles, VPC Lattice, Verified Access
- `service-config.yml` - API Gateway, Lambda function
- `backend.py` - Web server with AWS integration
- `web-app.html` - Interactive demo interface
- `deploy.sh` - Automated deployment
- `demo-script.sh` - Command line demonstration
- `cleanup.sh` - Resource cleanup

## Demo Flow

1. **Authentication**: Contractor credentials → IAM role assumption
2. **API Access**: Authenticated request → API Gateway → Lambda
3. **Service Test**: Backend service communication validation

## Web Demo Usage

1. Start the web demo: `source venv/bin/activate && python3 backend.py`
2. Use default values in Step 1: `contractor-001` and `abc123def456`
3. Click "🔐 Authenticate" - should succeed if AWS credentials are valid
4. Click "🌐 Access Secure API" - calls your deployed Lambda function
5. Click "🔗 Test Service Network" - validates backend services

## Troubleshooting

- **Authentication fails**: Check AWS credentials with `aws sts get-caller-identity`
- **Stack deployment fails**: Ensure you have proper IAM permissions
- **API endpoint not found**: Verify `zero-trust-demo-services` stack deployed successfully

## Cleanup

```bash
chmod +x cleanup.sh
./cleanup.sh
# OR manually:
aws cloudformation delete-stack --stack-name zero-trust-demo-services
aws cloudformation delete-stack --stack-name zero-trust-demo-base
```