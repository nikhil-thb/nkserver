# nkserver: A Simple Lightweight HTTP Server

nkserver is a lightweight and simple HTTP server built using Python. It serves static content from a user-defined directory and provides a quick and easy way to set up a web server for local development or testing purposes.
Features:

    Lightweight: Written in Python, nkserver is minimalistic and doesn't require additional configuration or heavy dependencies.
    Customizable Server Directory: The server serves files from a user-defined folder, which can easily be changed to fit project requirements.
    Responsive and Creative Index Page: By default, it serves a creative index.html page with effects such as blinking and fading text, and includes information about the server's status (such as the port number it's running on).
    Port Configuration: The server runs on a configurable port (default is 8000) and serves content over HTTP.
    Systemd Integration: The server can run as a background service on Linux using systemd, ensuring it starts on boot and remains running.
    Easy Installation: The server is packaged with an easy-to-use installation script that sets everything up for you automatically.
    User-Friendly Command: A globally accessible command (nkserver) allows you to start and manage the server easily.

# How It Works:

    Installation:
        Run a simple shell script to install all necessary dependencies (Python 3 and pip).
        The script prompts you to enter your domain (or use localhost if you don’t have one).
        It sets up the server directory, installs the Python script, and configures a systemd service to manage the server in the background.

    Serving Content:
        By default, the server looks for files in the /home/<user>/nkserver directory.
        The server can be customized to serve additional static content like HTML, CSS, JavaScript, and images.
        If no file is found, the server responds with a simple 404 Not Found page.

    Creative Index Page:
        A default index.html page is created during installation with creative effects like text blinking and fading. The page displays a welcome message, the port number the server is running on, and the domain or localhost for local access.

    Accessing the Server:
        Once the installation is complete, the server can be accessed at: http://<domain>:8000.
        You can copy your own project files into the nkserver folder to make them publicly available.

    Global Command:
        The installation script creates a globally accessible command nkserver to easily manage the server.

# Steps to Clone and Run nkserver from GitHub
1. Clone the Repository

First, clone the nkserver repository from GitHub:

git clone https://github.com/nikhil-thb/nkserver.git

This command will create a directory named nkserver in your current directory.
2. Change to the nkserver Directory

After cloning, navigate into the nkserver directory:

cd nkserver

3. Install Dependencies

Ensure that Python 3 and pip are installed on your system. You can install them using the following commands:

sudo apt update
sudo apt install -y python3 python3-pip

4. Run the Installation Script

In the nkserver directory, you should now see the install_nkserver.sh script. Make the script executable and run it:

chmod +x install_nkserver.sh
./install_nkserver.sh

This script will:

    Install necessary dependencies (like Python and required packages).
    Ask for your domain name (or default to localhost if none is provided).
    Set up the server directory, configuration files, and create a systemd service to run the server automatically in the background.

5. Follow the Installation Prompts

During the installation, the script will:

    Prompt you to enter a domain name (or use localhost if you don't have one).
    Set up the server directory (/home/<your-username>/nkserver), configure nkserver.py and index.html, and create a systemd service to keep the server running.

6. Start the nkserver Service

Once the installation is complete, the nkserver service will start automatically. You can verify that the service is running by checking the service status:

sudo systemctl status nkserver

If you need to manually start or stop the server:

# Start the nkserver service
sudo systemctl start nkserver

# Stop the nkserver service
sudo systemctl stop nkserver

7. Access the Server

Once the service is running, you can access your server through a web browser:

    If you entered localhost as the domain during installation, the server will be available at:

http://localhost:8000

If you provided a custom domain (e.g., example.com), access it via:

    http://example.com:8000

8. Copy Your Project Files to the nkserver Folder

The server will serve files from the directory you specified during installation (default is /home/your-username/nkserver). You can copy your project files (e.g., index.html, CSS, JS files) into that directory to serve them.

cp -r /path/to/your/project/* /home/your-username/nkserver/

9. Run nkserver Manually (Optional)

If you want to run nkserver manually without using systemd, you can do so by running the command (after the installation script sets it up):

nkserver

This will start the server on port 8000 by default.
