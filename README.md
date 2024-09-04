# Laravel-VhostNginxQL-Linux

**Laravel-VhostNginxQL-Linux** is a bash script designed to simplify the management of local development environments for Laravel projects. It automates the creation of virtual hosts, and manages Nginx, PHP-FPM, and MySQL services on a Linux system.

## Features

- **Virtual Host Management**: Automatically create and manage virtual hosts for Laravel projects within a specified working directory.
- **Service Control**: Easily start, stop, and restart Nginx, PHP-FPM, and MySQL services.
- **Customizable**: Designed to be easily adapted for different environments and configurations.

## Prerequisites

Before using this script, ensure that the following are installed on your Linux system:

- Nginx
- PHP 8.3 (with PHP-FPM)
- MySQL
- Bash

## Installation

1. Clone this repository or download the script directly:

   ```bash
   git clone https://github.com/kafitramarna/Laravel-VhostNginxQL-Linux.git
   cd Laravel-VhostNginxQL-Linux
   ```

2. Make the script executable:

   ```bash
   chmod +x script.sh
   ```

## Usage

- **Set the working directory**:
  
  **Note**: If using manually, create a file named `workdir.txt` and specify your working directory within this file.

- **Start Services**:

   To start the services and set up virtual hosts:

   ```bash
   ./script.sh start
   ```

- **Stop Services**:

   To stop the services:

   ```bash
   ./script.sh stop
   ```

- **Restart Services**:

   To restart the services:

   ```bash
   ./script.sh restart
   ```

## Virtual Host Configuration

The script automatically creates virtual hosts based on the directories within your working directory. Each directory will have its own virtual host with the format:

   ```bash
   http://dev.<directory-name>.test
   ```

## Troubleshooting

- **Permission Denied**: Ensure the script has executable permissions (`chmod +x script.sh`).
- **Service Start Errors**: Make sure Nginx, PHP-FPM, and MySQL are installed and configured correctly on your system.

## Contributing

Feel free to fork this project, submit issues, or make pull requests. Contributions are welcome!
