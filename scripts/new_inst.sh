#!/bin/bash

# Give Termux access to user directory
termux-setup-storage

# Upgrade packages
echo "Upgrading packages..."
apt update && apt upgrade -y

# Install mandatory packages
echo "Installing mandatory packages..."
apt install -y build-essential openssh curl git wget subversion silversearcher-ag imagemagick proot proot-distro python bsdtar mutt nmap neovim

# Install Debian
echo "Installing Debian..."
proot-distro install debian

# Login to Debian
echo "Logging into Debian..."
proot-distro login debian <<EOF

# Inside proot-distro

# Update and upgrade Debian packages
echo "Updating and upgrading Debian packages..."
apt update && apt upgrade -y

# Install essential packages in Debian
echo "Installing essential packages in Debian..."
apt install -y apt-utils build-essential cmake neovim git wget subversion imagemagick nano ranger python3-venv

# Install Python 3 and related packages
echo "Installing Python 3 and libraries..."
apt install -y python3-pip python3-numpy python3-scipy python3-matplotlib python3-mpmath python3-sympy python3-cvxopt

# Install Neovim, Ranger, and dependencies
echo "Installing Neovim and Ranger..."
apt install -y neovim ranger libxtst-dev libx11-dev python3-pynvim

# Install ueberzug for image support in Neovim
echo "Installing ueberzug..."
pip3 install ueberzug

# Install LaTeX
echo "Installing LaTeX..."
apt install -y texlive-full gnumeric

# Download LaTeX template
echo "Downloading LaTeX template..."
svn co https://github.com/gadepall/training/trunk/math

# Compile LaTeX document
echo "Compiling LaTeX document..."
texfot pdflatex main.tex

# Run Python script
echo "Running Python script..."
python3 codes/tri_sss.py

# Setting up vim-plug for Neovim
echo "Installing vim-plug..."
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -fLo ~/.config/nvim/init.vim --create-dirs https://raw.githubusercontent.com/gadepall/termux/main/neovim/init.vim

# Open Neovim to install plugins
echo "Opening Neovim to install plugins..."
nvim ~/.config/nvim/init.vim <<PLUGINS
:PlugInstall
:qa!
PLUGINS

# Notify user to update remote plugins
echo "Run the following command in Neovim to update remote plugins:"
echo ":UpdateRemotePlugins"

EOF

echo "Setup completed successfully!"
