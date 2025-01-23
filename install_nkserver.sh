#!/bin/bash

# Exit on error
set -e

# Variables
USER=$(whoami)
SERVER_DIR="/home/$USER/nkserver"  # Modify to your preferred installation directory
SCRIPT_PATH="$SERVER_DIR/nkserver.py"
SERVICE_FILE="/etc/systemd/system/nkserver.service"
INDEX_HTML="$SERVER_DIR/index.html"
PORT=8000  # Port to run the server on
NKSERVER_BIN="/usr/local/bin/nkserver"  # Path to the command

# 1. Install dependencies (Python3)
echo "Installing dependencies..."
sudo apt update
sudo apt install -y python3 python3-pip

# 2. Create the nkserver directory
echo "Creating server directory: $SERVER_DIR"
mkdir -p "$SERVER_DIR"

# 3. Prompt the user for their domain name
echo "Please enter your domain name (e.g., example.com). If you don't have one, type 'localhost':"
read DOMAIN_NAME

# Default to 'localhost' if the user doesn't provide a domain
if [ -z "$DOMAIN_NAME" ]; then
    DOMAIN_NAME="localhost"
    echo "No domain provided. Using 'localhost' as the domain."
fi

# 4. Create the sample index.html page with the port number and creative effects
echo "Creating sample index.html page..."
cat > "$INDEX_HTML" <<EOL
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>nkserver</title>
    <style>
        body {
            background-color: #121212;
            color: #ffffff;
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 20px;
        }

        h1 {
            font-size: 3em;
            animation: blink 1.5s infinite;
            color: #ff4081; /* Creative neon pink effect */
        }

        p {
            font-size: 1.5em;
            color: #cccccc;
        }

        .highlight {
            color: #76ff03; /* Neon green for special text */
            font-weight: bold;
        }

        /* Blinking effect */
        @keyframes blink {
            0% { opacity: 1; }
            50% { opacity: 0; }
            100% { opacity: 1; }
        }

        .fade {
            animation: fadeIn 3s ease-in-out forwards;
        }

        /* Fading in effect */
        @keyframes fadeIn {
            0% { opacity: 0; }
            100% { opacity: 1; }
        }
    </style>
</head>
<body>
    <h1 class="fade">Welcome to nkserver!</h1>
    <p>nk server running successfully on port: <span class="highlight">$PORT</span></p>
    <p>Access your server at: <span class="highlight">http://$DOMAIN_NAME:$PORT</span></p>
</body>
</html>
EOL

# 5. Create the Python server script
echo "Creating the nkserver Python script..."
cat > "$SCRIPT_PATH" <<EOL
import os
import socket
from urllib.parse import unquote

# Path to the directory where static content will be served from
STATIC_DIR = '/home/$USER/nkserver'

# Function to create the necessary folder structure
def create_directory_structure():
    if not os.path.exists(STATIC_DIR):
        print(f"Directory {STATIC_DIR} does not exist. Creating it now...")
        try:
            os.makedirs(STATIC_DIR)  # Create the main directory
            print(f"Directory {STATIC_DIR} created successfully.")
        except Exception as e:
            print(f"Error creating directory: {e}")
            exit(1)
    else:
        print(f"Directory {STATIC_DIR} already exists.")

def serve_file(client_socket, file_path):
    full_path = os.path.join(STATIC_DIR, file_path)
    
    if os.path.exists(full_path) and os.path.isfile(full_path):
        with open(full_path, 'rb') as file:
            content = file.read()

        ext = os.path.splitext(file_path)[-1].lower()
        if ext == '.html':
            content_type = 'text/html'
        elif ext == '.css':
            content_type = 'text/css'
        elif ext == '.js':
            content_type = 'application/javascript'
        elif ext in ['.jpg', '.jpeg']:
            content_type = 'image/jpeg'
        elif ext == '.png':
            content_type = 'image/png'
        elif ext == '.gif':
            content_type = 'image/gif'
        else:
            content_type = 'application/octet-stream'

        response = f"HTTP/1.1 200 OK\nContent-Type: {content_type}\n\n"
        client_socket.sendall(response.encode('utf-8'))
        client_socket.sendall(content)
    else:
        response = "HTTP/1.1 404 Not Found\nContent-Type: text/html\n\n" \
                   "<html><body><h1>404 Not Found</h1></body></html>"
        client_socket.sendall(response.encode('utf-8'))

def handle_request(client_socket):
    request = client_socket.recv(1024).decode('utf-8')
    print("Request received:")
    print(request)

    request_line = request.split("\n")[0]
    method, path, _ = request_line.split()

    path = unquote(path)
    if path == '/':
        path = '/index.html'  # Default to index.html

    serve_file(client_socket, path.lstrip('/'))  # Strip the leading slash from path

    client_socket.close()

def start_server(host='0.0.0.0', port=8000):  # Changed port to 8000
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind((host, port))
    server_socket.listen(5)

    print(f"Server running on {host}:{port}")
    
    while True:
        client_socket, client_address = server_socket.accept()
        print(f"Connection from {client_address}")
        handle_request(client_socket)

if __name__ == "__main__":
    create_directory_structure()
    start_server()
EOL

# 6. Create a shell command for nkserver to be used globally
echo "Creating the nkserver shell command..."
cat > "$NKSERVER_BIN" <<EOL
#!/bin/bash
python3 /home/$USER/nkserver/nkserver.py "\$@"
EOL

# 7. Make the shell script executable
sudo chmod +x "$NKSERVER_BIN"

# 8. Create the systemd service file to run as root
echo "Creating systemd service file..."
sudo tee "$SERVICE_FILE" > /dev/null <<EOL
[Unit]
Description=nkserver - Simple HTTP Server
After=network.target

[Service]
ExecStart=/usr/bin/python3 $SCRIPT_PATH
WorkingDirectory=$SERVER_DIR
User=root
Group=root
Restart=always

[Install]
WantedBy=multi-user.target
EOL

# 9. Reload systemd and enable the service
echo "Reloading systemd and enabling nkserver service..."
sudo systemctl daemon-reload
sudo systemctl enable nkserver.service

# 10. Start the nkserver service
echo "Starting nkserver service..."
sudo systemctl start nkserver.service

# 11. Check the status of the service
echo "Checking nkserver service status..."
sudo systemctl status nkserver.service

# Final message
echo -e "\nInstallation complete! You can access your server at http://$DOMAIN_NAME:$PORT/"
echo "Copy your project files into the following directory:"
echo "$SERVER_DIR"

echo "To enable SSL later, you can use the 'nkserver ssl <your-domain>' command (if needed)."
