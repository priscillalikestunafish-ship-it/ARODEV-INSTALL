#!/bin/bash
set -e

echo "Building Aro OS ISO..."

# Install archiso
pacman -Sy --noconfirm archiso git wget unzip

# Create working directory
WORK_DIR="/github/workspace/aro-build"
mkdir -p $WORK_DIR
cd $WORK_DIR

# Copy archiso profile
cp -r /usr/share/archiso/configs/releng/ $WORK_DIR/aroiso
cd aroiso

# Add packages
cat >> packages.x86_64 << 'EOF'

# Aro OS Developer Edition Packages
xorg
xorg-xinit
xf86-input-libinput
xf86-input-evdev
xf86-video-vmware
mesa
xfce4
xfce4-goodies
lightdm
lightdm-gtk-greeter
firefox
networkmanager
pulseaudio
pulseaudio-bluetooth
bluez
bluez-utils
blueman
git
wget
nano
vim
neovim
sudo
base-devel
xorg-xcursorgen
code
gcc
clang
python
python-pip
nodejs
npm
rust
go
jdk-openjdk
docker
postgresql
mysql
sqlite
redis
tmux
htop
tree
EOF

# Create branding
mkdir -p airootfs/etc
cat > airootfs/etc/issue << 'EOF'
    _             ___  ____    ____             
   / \   _ __ ___/ _ \/ ___|  |  _ \  _____   __
  / _ \ | '__/ _ \ | | \___ \  | | | |/ _ \ \ / /
 / ___ \| | | (_) | |_|___) | | |_| |  __/\ V / 
/_/   \_\_|  \___/ \__|____/  |____/ \___| \_/  

Aro OS Developer Edition
Kernel: \r

Welcome to Aro OS!
EOF

echo "aro-dev" > airootfs/etc/hostname

# Build ISO
mkarchiso -v -w $WORK_DIR/work -o /github/workspace/out $WORK_DIR/aroiso

# Rename ISO
cd /github/workspace/out
mv *.iso aro-os-dev-$(date +%Y.%m.%d)-x86_64.iso

echo "ISO build complete!"
