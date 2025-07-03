#!/bin/bash

set -e  # exit if any command fails
echo "Starting BindCraft setup..."

# Step 1: Install Miniconda
echo "Installing Miniconda..."
wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p $HOME/miniconda3
eval "$($HOME/miniconda3/bin/conda shell.bash hook)"
conda init
source ~/.bashrc

# Step 2: Install Mamba
echo "Installing Mamba..."
conda install -n base -c conda-forge mamba -y

# Step 3: Clone BindCraft and install
echo "Cloning and installing BindCraft..."
git clone https://github.com/martinpacesa/BindCraft ~/bindcraft
cd ~/bindcraft

bash install_bindcraft.sh --cuda '12.4' --pkg_manager 'mamba'

echo "BindCraft setup complete."
echo 'To activate environment:'
echo '  mamba activate BindCraft'
