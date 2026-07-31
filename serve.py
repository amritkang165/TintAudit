import http.server
import socketserver
import os

os.chdir(os.path.dirname(os.path.abspath(__file__)))


class Handler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cache-Control", "no-cache, no-store, must-revalidate")
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")
        super().end_headers()

    def log_message(self, format, *args):
        pass


with socketserver.ThreadingTCPServer(("", 8080), Handler) as httpd:
    print("Serving on http://localhost:8080 (cache disabled)")
    httpd.serve_forever()
