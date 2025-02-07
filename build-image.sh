#!/bin/bash

# Variables
IMAGE_XZ="2024-11-19-raspios-bookworm-arm64-full.img.xz"
IMAGE="${IMAGE_XZ%.xz}"
MOUNT_DIR="/mnt/raspios"
QEMU_STATIC="/usr/bin/qemu-aarch64-static"
LOCAL_QT_DIR="./Qt"              # Path to the local Qt directory
IMAGE_QT_DIR="/opt/Qt"           # Path inside the image where Qt will be copied
LOCAL_QT_APP="./my_qt_app"       # Path to the local Qt application
IMAGE_QT_APP="/opt/Qt/my_qt_app" # Path inside the image where the Qt app will be copied
QT_ENV_FILE="/etc/profile.d/qt.sh"  # Environment file for Qt variables
QT_APP_NAME="my_qt_app"          # Name of your Qt application
SERVICE_FILE="/etc/systemd/system/${QT_APP_NAME}.service"  # Systemd service file

# List of tools to install
TOOLS=(
  "vim"
  "git"
  "python3-pip"
  "curl"
  "wget"
  "cmake"
  # Add more tools here
)

# Function to install QEMU on the development machine
install_qemu() {
  echo "Checking for QEMU installation..."
  if ! command -v qemu-aarch64-static &> /dev/null; then
    echo "QEMU not found. Installing qemu-user-static..."
    if command -v apt &> /dev/null; then
      sudo apt update
      sudo apt install -y qemu-user-static binfmt-support
    elif command -v brew &> /dev/null; then
      brew install qemu
    else
      echo "Unsupported package manager. Please install qemu-user-static manually."
      exit 1
    fi
  else
    echo "QEMU is already installed."
  fi
}

# Function to install required tools
install_tools() {
  echo "Updating package list..."
  apt update

  echo "Installing required tools..."
  for tool in "${TOOLS[@]}"; do
    echo "Installing $tool..."
    apt install -y "$tool"
  done

  echo "Cleaning up..."
  apt clean
  rm -rf /var/lib/apt/lists/*
}

# Function to copy Qt folder to the image
copy_qt_folder() {
  echo "Copying Qt folder from $LOCAL_QT_DIR to $IMAGE_QT_DIR..."
  if [ -d "$LOCAL_QT_DIR" ]; then
    mkdir -p "$MOUNT_DIR/$IMAGE_QT_DIR"
    cp -r "$LOCAL_QT_DIR"/* "$MOUNT_DIR/$IMAGE_QT_DIR/"
  else
    echo "Local Qt directory $LOCAL_QT_DIR not found. Skipping Qt copy."
    exit 1
  fi
}

# Function to copy Qt application to the image
copy_qt_application() {
  echo "Copying Qt application from $LOCAL_QT_APP to $IMAGE_QT_APP..."
  if [ -f "$LOCAL_QT_APP" ]; then
    mkdir -p "$MOUNT_DIR/$(dirname "$IMAGE_QT_APP")"
    cp "$LOCAL_QT_APP" "$MOUNT_DIR/$IMAGE_QT_APP"
    chmod +x "$MOUNT_DIR/$IMAGE_QT_APP"  # Ensure the application is executable
  else
    echo "Local Qt application $LOCAL_QT_APP not found. Skipping application copy."
    exit 1
  fi
}

# Function to set Qt environment variables
set_qt_env() {
  echo "Setting Qt environment variables in $QT_ENV_FILE..."
  cat <<EOF | sudo tee "$MOUNT_DIR/$QT_ENV_FILE" > /dev/null
export QT_HOME="$IMAGE_QT_DIR"
export CMAKE_PREFIX_PATH=\$QT_HOME
export PATH=\$QT_HOME/bin:\$PATH
EOF
  chmod +x "$MOUNT_DIR/$QT_ENV_FILE"
}

# Function to create a systemd service for the Qt application
create_qt_service() {
  echo "Creating systemd service for $QT_APP_NAME..."
  cat <<EOF | sudo tee "$MOUNT_DIR/$SERVICE_FILE" > /dev/null
[Unit]
Description=My Qt Application
After=network.target

[Service]
ExecStart=$IMAGE_QT_APP
Restart=always
User=pi
Environment="QT_HOME=$IMAGE_QT_DIR"
Environment="CMAKE_PREFIX_PATH=$IMAGE_QT_DIR"
Environment="PATH=$IMAGE_QT_DIR/bin:\$PATH"

[Install]
WantedBy=multi-user.target
EOF

  # Enable the service
  chroot "$MOUNT_DIR" systemctl enable "$QT_APP_NAME.service"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use
