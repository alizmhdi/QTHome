#!/bin/bash

# Variables
IMAGE_XZ="2024-11-19-raspios-bookworm-arm64-full.img.xz"
IMAGE="${IMAGE_XZ%.xz}"
MOUNT_DIR="/mnt/raspios"
QEMU_STATIC="/usr/bin/qemu-aarch64-static"
LOCAL_QT_DIR="./Qt"              # Path to the local Qt directory
IMAGE_QT_DIR="/opt/Qt"           # Path inside the image where Qt will be copied
QT_ENV_FILE="/etc/profile.d/qt.sh"  # Environment file for Qt variables

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

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use sudo."
  exit 1
fi

# Step 0: Install QEMU on the development machine
install_qemu

# Step 1: Extract the .img.xz file
echo "Extracting $IMAGE_XZ..."
if [ ! -f "$IMAGE" ]; then
  unxz -k "$IMAGE_XZ"
else
  echo "$IMAGE already exists. Skipping extraction."
fi

# Step 2: Mount the image
echo "Mounting $IMAGE..."
LOOP_DEVICE=$(losetup -fP --show "$IMAGE")
mkdir -p "$MOUNT_DIR"
mount "${LOOP_DEVICE}p2" "$MOUNT_DIR"
mount "${LOOP_DEVICE}p1" "$MOUNT_DIR/boot"

# Step 3: Copy QEMU static binary into the image
echo "Setting up QEMU for ARM64 emulation..."
if [ ! -f "$QEMU_STATIC" ]; then
  echo "QEMU static binary not found. Please install qemu-user-static."
  exit 1
fi
cp "$QEMU_STATIC" "$MOUNT_DIR/usr/bin/"

# Step 4: Copy Qt folder to the image
copy_qt_folder

# Step 5: Set Qt environment variables
set_qt_env

# Step 6: Chroot into the image and install tools
echo "Chrooting into the image..."
chroot "$MOUNT_DIR" qemu-aarch64-static /bin/bash <<EOF
echo "Inside chroot environment."
$(declare -f install_tools)
install_tools
echo "Exiting chroot environment."
EOF

# Step 7: Unmount the image
echo "Unmounting the image..."
umount "$MOUNT_DIR/boot"
umount "$MOUNT_DIR"
rmdir "$MOUNT_DIR"
losetup -d "$LOOP_DEVICE"

# Step 8: (Optional) Compress the image back to .img.xz
echo "Compressing the image back to .img.xz..."
if [ -f "$IMAGE_XZ" ]; then
  echo "$IMAGE_XZ already exists. Skipping compression."
else
  xz -z "$IMAGE"
fi

echo "Done! Modified image: $IMAGE_XZ"
