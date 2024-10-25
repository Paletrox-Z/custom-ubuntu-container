
# Custom Ubuntu Docker Image with MATE Desktop

This repository provides a Dockerfile to create a custom, disposable Ubuntu Docker image with the Ubuntu MATE Desktop and VNC support. The image is designed to be a pre-configured desktop environment that you can use interactively via VNC, perfect for testing, experimenting, or just a quick graphical Ubuntu environment within Docker.

## Overview

The Docker image is based on Ubuntu and includes:
- The MATE desktop environment for a lightweight GUI.
- VNC server support for remote desktop access.
- Utilities like `nano`, `chromium`, and `qbittorrent`.

Currently, this setup has been tested on `x64` architecture, but it can be adapted for `arm64` by modifying the base image in the Dockerfile.

### Example of Changing Base Image to ARM64
To use `arm64`, simply modify the first line in the Dockerfile:
```dockerfile
FROM ubuntu:24.04-arm64
```

> **Note:** This setup is for casual use and lacks additional security hardening beyond the default Ubuntu security. Use responsibly, and avoid exposing sensitive data.

---

 **Default Password for user (nonroot) and VNC:** `abcd1234`

 Sudo access is allowed without requiring a password, so feel free to change this option in Dockerfile by removing the line below:

 ```Dockerfile
 RUN echo 'nonroot       ALL=(ALL)       NOPASSWD:ALL' >> /etc/sudoers
 ```

---

## Getting Started

### Prerequisites

To get started, ensure you have the following:
1. A system with Docker installed and running.
2. `x64` architecture (tested) or an ARM-compatible system if modifying for `arm64`.
3. Sufficient system resources (CPU/RAM) to run a desktop environment within Docker.
4. A stable internet connection to download resources during the build.

### Installation and Usage

#### On Windows
Run the provided batch script to build and deploy the Docker image:
```batch
build-deploy.bat
```

#### On Linux/macOS
Make the provided script executable, then run it:
```bash
chmod +x build-deploy.sh
./build-deploy.sh
```

The script will:
1. Build the Docker image based on the Dockerfile.
2. Deploy a container with the pre-configured MATE desktop and VNC support.
3. Automatically remove the container after you exit by pressing `Ctrl + C`.

Alternatively, you can perform the build and run steps manually by following the instructions in the `build-deploy.bat` or `build-deploy.sh`.

---

## Manual Steps to Build and Run the Image

If you'd like to avoid using the script, follow these commands manually:

1. **Build the Docker image:**
   ```bash
   docker build -t custom-ubuntu-mate .
   ```

2. **Run the container:**
   ```bash
   docker run -it --rm -p 5901:5901 custom-ubuntu-mate
   ```

3. **Connect via VNC:**
   Use a VNC viewer to connect to `localhost:5901`.

> **Note:** The default VNC password is set in the Dockerfile. Change it if necessary.

---

## Additional Notes

- **Network Configuration**: The firewall (UFW) is configured to allow access to port `5901` for VNC connections.
- **User Setup**: A non-root user with sudo privileges is created, and passwordless sudo is enabled.
- **Environment Variables**: Some necessary environment variables like `DISPLAY` are pre-set to ensure a smooth GUI experience.

---

### Resources

For additional configuration and troubleshooting, refer to the following:
1. [How to Install and Configure VNC Server on Ubuntu](https://bytexd.com/how-to-install-configure-vnc-server-on-ubuntu/)
2. [Docker Documentation](https://docs.docker.com/)
2. [ChatGPT](https://chatgpt.com/)

---

Feel free to explore, modify, and use this setup in a way that fits your needs. Enjoy your disposable Ubuntu MATE desktop in Docker!
