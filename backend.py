#!/usr/bin/env python3
import http.server
import socketserver
import json
import boto3
import webbrowser
import os
from botocore.exceptions import ClientError

PORT = 8181

class ZeroTrustHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=os.path.dirname(os.path.abspath(__file__)), **kwargs)

    def do_POST(self):
        if self.path == '/api/authenticate':
            self.handle_authenticate()
        elif self.path == '/api/access':
            self.handle_api_access()
        elif self.path == '/api/service':
            self.handle_service_test()
        else:
            self.send_error(404)

    def handle_authenticate(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        data = json.loads(post_data.decode('utf-8'))
        
        try:
            cf = boto3.client('cloudformation')
            stack = cf.describe_stacks(StackName='zero-trust-demo-base')
            role_arn = next((o['OutputValue'] for o in stack['Stacks'][0]['Outputs'] 
                           if o['OutputKey'] == 'ContractorRoleArn'), None)
            
            if role_arn:
                sts = boto3.client('sts')
                response = sts.assume_role(
                    RoleArn=role_arn,
                    RoleSessionName='contractor-session',
                    ExternalId='demo-contractor'
                )
                result = {
                    'success': True,
                    'roleArn': role_arn,
                    'sessionToken': response['Credentials']['SessionToken'][:20] + '...'
                }
            else:
                result = {'success': False, 'message': 'Role not found'}
        except Exception as e:
            result = {'success': False, 'message': str(e)}
        
        self.send_json_response(result)

    def handle_api_access(self):
        try:
            cf = boto3.client('cloudformation')
            stack = cf.describe_stacks(StackName='zero-trust-demo-services')
            api_endpoint = next((o['OutputValue'] for o in stack['Stacks'][0]['Outputs'] 
                               if o['OutputKey'] == 'ApiEndpoint'), None)
            
            lambda_client = boto3.client('lambda')
            response = lambda_client.invoke(
                FunctionName='zero-trust-demo-api-function',
                InvocationType='RequestResponse'
            )
            payload = json.loads(response['Payload'].read())
            
            result = {'success': True, 'endpoint': api_endpoint, 'response': payload}
        except Exception as e:
            result = {'success': False, 'message': str(e)}
        
        self.send_json_response(result)

    def handle_service_test(self):
        try:
            # Simulate service network test since VPC Lattice may not be available
            lambda_client = boto3.client('lambda')
            functions = lambda_client.list_functions()
            demo_functions = [f['FunctionName'] for f in functions['Functions'] 
                            if 'zero-trust-demo' in f['FunctionName']]
            
            result = {
                'success': True,
                'serviceNetwork': 'API Gateway + Lambda',
                'services': demo_functions
            }
        except Exception as e:
            result = {'success': False, 'message': str(e)}
        
        self.send_json_response(result)

    def send_json_response(self, data):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        self.wfile.write(json.dumps(data).encode())

if __name__ == "__main__":
    print("🚀 Starting Zero Trust Demo with AWS Integration...")
    print(f"📱 Server running at: http://localhost:{PORT}")
    
    try:
        boto3.client('sts').get_caller_identity()
        print("✅ AWS credentials configured")
    except Exception as e:
        print(f"⚠️  AWS credentials not configured: {e}")
    
    with socketserver.TCPServer(("", PORT), ZeroTrustHandler) as httpd:
        webbrowser.open(f'http://localhost:{PORT}/web-app.html')
        print("✅ Demo ready! Press Ctrl+C to stop")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\n🛑 Demo stopped")