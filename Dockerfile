# Use the official Ubuntu 24.04 arm64 as the base image
FROM ubuntu:24.04

LABEL author="Paletrox Z"
LABEL version="1-ALPHA"
LABEL description="A simple Ubuntu container with Ubuntu Mate Desktop to be used inside docker"

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

# Update the package list, upgrade packages, and install some packages

RUN apt update && apt upgrade -y
RUN apt install -y ubuntu-mate-desktop
RUN apt install -y sudo nano tightvncserver curl \
        net-tools riseup-vpn qbittorrent dbus-x11 x11-xserver-utils \
        software-properties-common
RUN curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|tee /etc/apt/sources.list.d/brave-browser-release.list
RUN apt update
RUN apt install brave-browser -y

# Enable firewall access to port 5901
RUN ufw allow 5901
RUN ufw reload

# Create a new user and add to sudo group
RUN useradd -m -s /bin/bash nonroot && echo 'nonroot:abcd1234' | chpasswd && usermod -aG sudo nonroot

# Allow the new user to run sudo commands without a password
RUN echo 'nonroot       ALL=(ALL)       NOPASSWD:ALL' >> /etc/sudoers

# Copy configuration files
COPY ./files/start_vnc.sh /usr/local/bin/
COPY ./files/xstartup /home/nonroot/.vnc/
COPY ./files/brave-browser.desktop /usr/share/applications/

# Change ownership of the VNC configuration files
RUN chown -R nonroot:nonroot /home/nonroot/

# Make start vnc executable
RUN chmod a+x /usr/local/bin/start_vnc.sh

# Switch to the new user
USER nonroot

# Set up VNC password
RUN echo "abcd1234" | vncpasswd -f > /home/nonroot/.vnc/passwd && chmod 600 /home/nonroot/.vnc/passwd

# Set necessary variables
RUN echo "\nexport USER=nonroot" >> /home/nonroot/.bashrc
RUN echo "\nexport DISPLAY=1" >> /home/nonroot/.bashrc

# Make script executable to start the VNC server
RUN chmod a+x /home/nonroot/.vnc/xstartup

# Symlink xstartup with .xinitrc
RUN ln -sf /home/nonroot/.vnc/xstartup /home/nonroot/.xinitrc

# Export required variable
RUN export USER=nonroot

# Go Home
RUN cd /home/nonroot

# Create XAuthority
RUN touch /home/nonroot/.Xauthority

# Set the default command to run when the container starts
ENTRYPOINT ["/usr/local/bin/start_vnc.sh"]

# Expose the VNC port
EXPOSE 5901