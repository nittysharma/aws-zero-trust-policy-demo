#!/usr/bin/env python3
import http.server
import socketserver
import webbrowser
import os

PORT = 8080

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=os.path.dirname(os.path.abspath(__file__)), **kwargs)

def start_demo():
    print("🚀 Starting Zero Trust Demo Web Application...")
    print(f"📱 Server running at: http://localhost:{PORT}")
    print("🌐 Opening browser automatically...")
    
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        # Open browser
        webbrowser.open(f'http://localhost:{PORT}/web-app.html')
        
        print("✅ Demo ready! Press Ctrl+C to stop")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\n🛑 Demo stopped")

if __name__ == "__main__":
    start_demo()