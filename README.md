# nkserver - Lightweight Web Server
nkserver is a lightweight web server that can serve static content based on domain-to-directory mappings. You can easily map your domain to a specific directory on your server and use SSL certificates for secure access.

# Table of Contents
Installation
Usage
Configuration
SSL Configuration
Uninstallation
Scripts and Automation
Contributing
Installation
To install nkserver on your system, follow these steps:

# Prerequisites:
Ubuntu/Debian-based systems (or any Linux system with apt).
Python 3 installed on your system.
Certbot (for SSL support).
A public domain name (e.g., yourdomain.com) pointing to your server's IP address.
Steps:
Clone the repository:

    git clone https://github.com/nikhil-thb/nkserver.git
    cd nkserver
Make the install script executable:

    chmod +x install.sh
Run the install script:

    sudo ./install.sh
    
During installation, the script will prompt you to enter your public IP address or domain name. If you have a public IP (or domain), enter it when asked.

Example prompt:

Enter the public IP or domain of your server (e.g., yourdomain.com or 192.168.1.100):
After this, the script will configure nkserver for your public IP or domain.

Start the server: The installation script will automatically start the nkserver service using systemd.

Usage
After installing nkserver, you can access it using your domain (e.g., https://yourdomain.com/) or IP address (e.g., https://<Your-IP-Address>/).

Add New Domains
To add a new domain to nkserver, run the following script:

    /etc/nkserver/add-domain.sh
    
This will prompt you for a domain name and create the necessary static directory, then configure SSL using Let's Encrypt.

Once the domain is added and SSL configured, you can access the content at:

    https://yourdomain.com/
Default Configuration
The default configuration file will serve content for localhost. You can add more domains through the provided script. Once added, nkserver will serve the corresponding static content.

Example Domain Addition:
When running the add-domain.sh script:

    Enter the domain name (e.g., example.com): example.com
This will create a folder at /var/www/nkserver/example.com/ and set up SSL for the domain using Let's Encrypt.

Configuration
The domain-to-folder mappings are stored in /etc/nkserver/nkserver.conf. The configuration file will map domain names to static folders.

Default configuration:

# Domain-to-static-folder mappings
localhost = /var/www/nkserver/localhost
yourdomain.com = /var/www/nkserver/yourdomain
This file is automatically updated when you add new domains via the add-domain.sh script.

SSL Configuration
nkserver supports SSL using Let's Encrypt. The add-domain.sh script automatically handles SSL configuration for each domain.

Automatic SSL Setup
When you add a new domain, nkserver will use Certbot to request an SSL certificate for your domain. The certificate is stored in /etc/letsencrypt/live/<domain>/.

After SSL is configured, you can access your domain securely using HTTPS:

    https://yourdomain.com/
Make sure that your domain points to your public IP, and that port 80 and 443 are open on your server for HTTP and HTTPS traffic.

Uninstallation
To uninstall nkserver, you can use the provided uninstall.sh script:

Run the uninstall script:

    sudo /etc/nkserver/uninstall.sh
This will stop and disable the nkserver service, remove the files, and clean up the configuration.

Scripts and Automation
    add-domain.sh
This script adds new domains to nkserver, creates static directories, and configures SSL certificates. It automates domain setup, including certificate retrieval from Let's Encrypt.

uninstall.sh
This script uninstalls nkserver, removes the web server files, and stops the service.

Installation Script (install.sh)
This script automates the installation of nkserver, including dependencies, directories, and configurations. It also prompts for the public IP or domain name to configure the server properly.

Contributing
Contributions are welcome! Feel free to submit issues or pull requests to improve the nkserver web server.

License
nkserver is open-source software released under the MIT License.

Final Thoughts
With nkserver, you can easily serve static content for multiple domains, manage SSL certificates automatically, and run your web server both locally and on public servers.

By following the above steps, you should be able to configure and use nkserver to serve content via your domain (e.g., https://yourdomain.com).

Let me know if you need further clarification!
