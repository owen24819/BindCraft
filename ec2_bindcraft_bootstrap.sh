#!/bin/bash

set -e  # exit if any command fails

if ! command -v nvidia-smi &> /dev/null; then
  echo "❌ nvidia-smi not found. Is the NVIDIA driver installed?"
  exit 1
fi

echo "🚀 Starting BindCraft setup..."

# Step 1: Install Miniconda
echo "📦 Installing Miniconda..."
wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $HOME/miniconda.sh
bash $HOME/miniconda.sh -b -p "$HOME/miniconda3"

# Step 2: Activate Conda in the current script
source "$HOME/miniconda3/etc/profile.d/conda.sh"

# Step 3: Install Mamba into base
echo "⚙️ Installing Mamba..."
conda install -n base -c conda-forge mamba -y

# Step 4: Install BindCraft
echo "🔧 Installing BindCraft with CUDA 12.4..."
bash install_bindcraft.sh --cuda '12.4' --pkg_manager 'mamba'
echo "✅ BindCraft setup complete."

# Step 5: Run bindcraft.py
echo "🚀 Running BindCraft..."

# Define settings file and output base directory
SETTINGS_FILE="./settings_target/PDL1.json"
FILTERS_FILE="./settings_filters/default_filters.json"
ADVANCED_FILE="./settings_advanced/default_4stage_multimer.json"
LOG_DIR="logs"

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Get number of GPUs
NUM_GPUS=$(nvidia-smi --query-gpu=name --format=csv,noheader | wc -l)
echo "🔍 Detected $NUM_GPUS GPU(s)."

# Run bindcraft.py on each GPU
for (( i=0; i<"NUM_GPUS"; i++ )); do
  echo "Starting BindCraft on GPU $i..."
  CUDA_VISIBLE_DEVICES=$i conda run -n BindCraft --no-capture-output \
    python bindcraft.py \
      --settings "$SETTINGS_FILE" \
      --filters "$FILTERS_FILE" \
      --advanced "$ADVANCED_FILE" \
    > "$LOG_DIR/run_gpu${i}.log" 2>&1 &
done

echo "All BindCraft jobs launched!"
wait
echo "All BindCraft jobs finished!"

echo "🔌 Shutting down instance..."
sudo shutdown -h now
