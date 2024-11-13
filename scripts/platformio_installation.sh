#!/bin/bash

# Create a virtual environment
python3 -m venv platformio-venv

# Activate the virtual environment
source platformio-venv/bin/activate

# Install PlatformIO
pip install platformio

# Verify the installation
pio --version

# Deactivate the virtual environment
deactivate
