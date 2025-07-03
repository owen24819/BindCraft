#!/bin/bash

set -e  # exit if any command fails
echo "🚀 Starting BindCraft setup..."

# Step 1: Install Miniconda
echo "📦 Installing Miniconda..."
wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p "$HOME/miniconda3"

# Step 2: Activate Conda in the current script (no need for conda init)
eval "$($HOME/miniconda3/bin/conda shell.bash hook)"

# Step 3: Install Mamba
echo "⚙️ Installing Mamba..."
conda install -n base -c conda-forge mamba -y

# Step 4: Install BindCraft
echo "🔧 Installing BindCraft with CUDA 12.4..."
bash install_bindcraft.sh --cuda '12.4' --pkg_manager 'mamba'

echo "✅ BindCraft setup complete."
echo "To activate environment manually:"
echo "  source ~/miniconda3/bin/activate BindCraft"
