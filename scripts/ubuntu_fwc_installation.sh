#!/bin/bash

# Update the system
echo "Updating the system..."
sudo apt update && sudo apt upgrade -y

# Install mandatory packages
echo "Installing mandatory packages..."
sudo apt install build-essential openssh-client curl git wget subversion silversearcher-ag imagemagick proot python3 python3-venv -y

# Install Neovim and Ranger
echo "Installing Neovim and Ranger..."
sudo apt install neovim ranger libxtst-dev libx11-dev python3-pynvim -y

# Install Python packages
echo "Installing Python packages..."
sudo apt install python3-pip -y
pip3 install numpy scipy matplotlib mpmath sympy cvxopt

# Install LaTeX
echo "Installing LaTeX..."
sudo apt install texlive-full gnumeric -y

echo "Setup complete!"
