#!/bin/bash

#Exit on error
set -e

#Set some variables
TERMUX_HOME=/data/data/com.termux/files/home
INSTALL_DIR=$TERMUX_HOME/symbiflow

#Change to TERMUX_HOME directory
cd $TERMUX_HOME

#Update package repos
apt update -y && apt upgrade -y

#Install new packages
apt install openssh-server sshpass build-essential libssl-dev libffi-dev python3-dev bison flex git-all git-lfs hub tcl-dev tcl tcl-tclreadline libreadline-dev  autoconf libtool make automake texinfo pkg-config libusb-1.0-0 libusb-1.0-0-dev gcc-arm-none-eabi libnewlib-arm-none-eabi telnet python3 apt-utils libxslt-dev cmake curl python3-pip python3-venv -y

#Create a python3 virtual environment for installed modules
python3 -m venv ~/.pyvenv

#Create directory to install the toolchain to
mkdir -p $TERMUX_HOME/symbiflow
echo "export INSTALL_DIR=$INSTALL_DIR" >> ~/.pyvenv/bin/activate
echo 'export PATH=$INSTALL_DIR/bin:$INSTALL_DIR/quicklogic-arch-defs/bin:$INSTALL_DIR/quicklogic-arch-defs/bin/python3:$PATH' >> ~/.pyvenv/bin/activate
cd $TERMUX_HOME

source ~/.pyvenv/bin/activate

#Install required python modules
pip3 install gdown lxml simplejson

#Download arch.tar.gz
gdown --fuzzy 'https://drive.google.com/uc?export=download&id=17gVGRJ1qcaWanYzyg1eMUiLlFqya3_ZD'

#Clone pygmy toolchain
if [ ! -d "$TERMUX_HOME/pygmy-dev" ]; then
    git clone --recursive https://github.com/optimuslogic/pygmy-dev
fi

#Download patches
wget https://raw.githubusercontent.com/goats-9/fwc-codes/main/resources/quicklogic-fasm.patch -O pygmy-dev/tools/quicklogic-fasm/quicklogic-fasm.patch
wget https://raw.githubusercontent.com/goats-9/fwc-codes/main/resources/quicklogic-yosys.patch -O pygmy-dev/tools/quicklogic-yosys/quicklogic-yosys.patch
wget https://raw.githubusercontent.com/goats-9/fwc-codes/main/resources/vtr-verilog-to-routing.patch -O pygmy-dev/tools/vtr-verilog-to-routing/vtr-verilog-to-routing.patch

tar -C $INSTALL_DIR -xvf arch.tar.gz

#Install fasm
cd $TERMUX_HOME/pygmy-dev/tools/quicklogic-fasm
git diff --quiet
if [ $? -eq 0 ]; then
    git apply quicklogic-fasm.patch
fi
pip3 install -r requirements.txt
python3 setup.py install

#Install yosys
cd $TERMUX_HOME/pygmy-dev/tools/quicklogic-yosys
git diff --quiet
if [ $? -eq 0 ]; then
    git apply quicklogic-yosys.patch
fi
make config-gcc
make -j4 install PREFIX=$INSTALL_DIR

#Install yosys symbiflow plugins
cd $TERMUX_HOME/pygmy-dev/tools/yosys-symbiflow-plugins
make -j4 install

#Install vtr
cd $TERMUX_HOME/pygmy-dev/tools/vtr-verilog-to-routing
git diff --quiet
if [ $? -eq 0 ]; then
    git apply vtr-verilog-to-routing.patch
fi
make -j4

#Copy executables onto PATH
cp build/vpr/vpr $INSTALL_DIR/bin/
cp build/utils/fasm/genfasm $INSTALL_DIR/bin/
