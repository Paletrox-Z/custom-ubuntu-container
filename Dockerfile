# Use the official Ubuntu 24.04 arm64 as the base image
FROM ubuntu:24.04

LABEL author="Paletrox Z"
LABEL version="1-ALPHA"
LABEL description="A simple Ubuntu container with Ubuntu Mate Desktop to be used inside docker"

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

# Update the package list, upgrade packages, and install mate-desktop
# Adding this step here to cache the step, otherwise the large packages needs to be downloaded again
RUN apt update && apt upgrade -y && apt install -y ubuntu-mate-desktop sudo nano \
        tightvncserver curl dbus-x11 x11-xserver-utils software-properties-common

# Enable firewall access to port 5901
RUN ufw allow 5901
RUN ufw reload

# Copy configuration files
COPY ./files/start_vnc.sh /usr/local/bin/
COPY ./files/xstartup /home/nonroot/.vnc/
COPY ./files/containered-brave-browser.desktop /usr/share/applications/

# Installing additional packages
# This is where other extra packages can be added in or removed
RUN curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|tee /etc/apt/sources.list.d/brave-browser-release.list
RUN apt update
RUN apt install brave-browser qbittorrent net-tools -y

# Create a new user and add to sudo group
RUN useradd -m -s /bin/bash nonroot && echo 'nonroot:abcd1234' | chpasswd && usermod -aG sudo nonroot

# Allow the new user to run sudo commands without a password
RUN echo 'nonroot       ALL=(ALL)       NOPASSWD:ALL' >> /etc/sudoers

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