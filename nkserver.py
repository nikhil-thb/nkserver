from flask import Flask, send_from_directory, abort, request
import os

app = Flask(__name__)

# Base directory for static files
BASE_DIR = "/var/www/nkserver"

# Configuration mapping (domain to directory)
config_file = "/etc/nkserver/nkserver.conf"
domain_mapping = {}

def load_config():
    """Load domain mappings from the configuration file."""
    global domain_mapping
    domain_mapping = {}
    if os.path.exists(config_file):
        with open(config_file, "r") as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith("#"):
                    domain, path = line.split("=")
                    domain_mapping[domain.strip()] = path.strip()

# Load configuration initially
load_config()

@app.route("/", defaults={"path": "index.html"})
@app.route("/<path:path>")
def serve_static(path):
    host = request.host.split(":")[0]  # Get the domain name
    static_folder = domain_mapping.get(host, None)

    if static_folder and os.path.exists(static_folder):
        return send_from_directory(static_folder, path)
    else:
        return abort(404, description="Domain not configured or path not found.")

if __name__ == "__main__":
    ssl_context = None
    cert_path = "/etc/letsencrypt/live/yourdomain.com/fullchain.pem"
    key_path = "/etc/letsencrypt/live/yourdomain.com/privkey.pem"

    if os.path.exists(cert_path) and os.path.exists(key_path):
        ssl_context = (cert_path, key_path)

    app.run(host="0.0.0.0", port=443 if ssl_context else 80, ssl_context=ssl_context)
