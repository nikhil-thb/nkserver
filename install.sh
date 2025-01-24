#!/bin/bash

echo "Installing nkserver..."

# Install required packages
sudo apt update
sudo apt install -y certbot python3-certbot python3-flask

# Function to prompt for system IP
get_system_ip() {
    echo "Please enter your system's IP address:"
    echo "If you have a public IP, enter your public IP address."
    echo "If you're running locally, enter your private IP address (you can get it using 'ifconfig' or 'ip a')."
    read -p "IP Address: " SYSTEM_IP
    if [ -z "$SYSTEM_IP" ]; then
        echo "IP address is required. Exiting..."
        exit 1
    fi
    echo "You entered: $SYSTEM_IP"
}

# Ask user for system's IP
get_system_ip

# Create required directories
sudo mkdir -p /etc/nkserver
sudo mkdir -p /var/www/nkserver/localhost

# Default content for localhost
echo "<h1>Welcome to nkserver (localhost)</h1>" | sudo tee /var/www/nkserver/localhost/index.html

# Create default configuration file with user-entered IP
sudo tee /etc/nkserver/nkserver.conf > /dev/null <<EOL
# Domain-to-static-folder mappings
$SYSTEM_IP = /var/www/nkserver/localhost
EOL

# Create the add-domain script
sudo tee /etc/nkserver/add-domain.sh > /dev/null <<'EOL'
#!/bin/bash

# Add a new domain to nkserver
read -p "Enter the domain name: " DOMAIN
STATIC_DIR="/var/www/nkserver/$DOMAIN"

# Create static folder
sudo mkdir -p "$STATIC_DIR"
echo "<h1>Welcome to $DOMAIN</h1>" | sudo tee "$STATIC_DIR/index.html"

# Update configuration
echo "$DOMAIN = $STATIC_DIR" | sudo tee -a /etc/nkserver/nkserver.conf

# Configure SSL
sudo certbot certonly --standalone -d "$DOMAIN"

# Restart the nkserver service
sudo systemctl restart nkserver

echo "Domain $DOMAIN added successfully!"
EOL

# Create the uninstall script
sudo tee /etc/nkserver/uninstall.sh > /dev/null <<'EOL'
#!/bin/bash

echo "Uninstalling nkserver..."

# Stop the nkserver service
sudo systemctl stop nkserver
sudo systemctl disable nkserver

# Remove nkserver files and directories
sudo rm -f /usr/local/bin/nkserver.py
sudo rm -f /etc/systemd/system/nkserver.service
sudo rm -rf /etc/nkserver
sudo rm -rf /var/www/nkserver

echo "nkserver uninstalled successfully!"
EOL

# Make the scripts executable
sudo chmod +x /etc/nkserver/add-domain.sh
sudo chmod +x /etc/nkserver/uninstall.sh

# Copy the server script
sudo cp nkserver.py /usr/local/bin/nkserver.py
sudo chmod +x /usr/local/bin/nkserver.py

# Create systemd service file
sudo tee /etc/systemd/system/nkserver.service > /dev/null <<EOL
[Unit]
Description=nkserver - Custom Web Server
After=network.target

[Service]
ExecStart=/usr/bin/python3 /usr/local/bin/nkserver.py
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOL

# Enable and start the service
sudo systemctl enable nkserver
sudo systemctl start nkserver

echo "nkserver installed successfully!"
echo "Default configuration created at /etc/nkserver/nkserver.conf."
echo "To add domains, use /etc/nkserver/add-domain.sh."
echo "To uninstall, use /etc/nkserver/uninstall.sh."
