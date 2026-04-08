#!/bin/bash
set -e

echo "=== ComfyUI SCAIL Pod Setup ==="

# -----------------------------------------------
# 1. Install system dependencies
# -----------------------------------------------
echo "[1/6] Installing system dependencies..."
apt-get update && apt-get install -y gcc g++ && rm -rf /var/lib/apt/lists/*

# -----------------------------------------------
# 2. Install custom nodes
# -----------------------------------------------
echo "[2/6] Installing custom nodes..."
cd /ComfyUI/custom_nodes
git clone https://github.com/kijai/ComfyUI-WanVideoWrapper
git clone https://github.com/kijai/ComfyUI-KJNodes
git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite
git clone https://github.com/kijai/ComfyUI-Florence2
git clone https://github.com/kijai/ComfyUI-GIMM-VFI
git clone https://github.com/lihaoyun6/ComfyUI-FlashVSR_Ultra_Fast
git clone https://github.com/kijai/ComfyUI-SCAIL-Pose
git clone https://github.com/kijai/ComfyUI-WanAnimatePreprocess

# -----------------------------------------------
# 3. Install Python dependencies
# -----------------------------------------------
echo "[3/6] Installing Python dependencies..."
cd /ComfyUI/custom_nodes/ComfyUI-WanVideoWrapper && pip install -r requirements.txt
cd /ComfyUI/custom_nodes/ComfyUI-KJNodes && pip install -r requirements.txt
cd /ComfyUI/custom_nodes/ComfyUI-VideoHelperSuite && pip install -r requirements.txt
cd /ComfyUI/custom_nodes/ComfyUI-Florence2 && pip install -r requirements.txt
cd /ComfyUI/custom_nodes/ComfyUI-GIMM-VFI && pip install -r requirements.txt
cd /ComfyUI/custom_nodes/ComfyUI-FlashVSR_Ultra_Fast && pip install -r requirements.txt
cd /ComfyUI/custom_nodes/ComfyUI-SCAIL-Pose && pip install -r requirements.txt
cd /ComfyUI/custom_nodes/ComfyUI-WanAnimatePreprocess && pip install -r requirements.txt
pip install sageattention

# -----------------------------------------------
# 4. Configure extra model paths (network volume)
# -----------------------------------------------
echo "[4/6] Configuring model paths..."
cat > /ComfyUI/extra_model_paths.yaml << 'EOF'
runpod:
  base_path: /workspace/models/
  checkpoints: checkpoints/
  clip: clip/
  clip_vision: clip_vision/
  configs: configs/
  controlnet: controlnet/
  diffusion_models: diffusion_models/
  embeddings: embeddings/
  loras: loras/
  text_encoders: text_encoders/
  upscale_models: upscale_models/
  unet: unet/
  vae: vae/
  detection: detection/
  nlf: nlf/
  other: other/
EOF

# Symlink FlashVSR model from network volume
ln -sf /workspace/models/FlashVSR-v1.1 /ComfyUI/models/FlashVSR-v1.1

# -----------------------------------------------
# 5. Download models to network volume (skip if already present)
# -----------------------------------------------
echo "[5/6] Downloading models to network volume..."
mkdir -p /workspace/models/{diffusion_models,vae,loras,clip_vision,nlf,detection,text_encoders}

download_if_missing() {
    local dest="$1"
    local url="$2"
    if [ -f "$dest" ]; then
        echo "  Already exists: $dest"
    else
        echo "  Downloading: $dest"
        wget -q --show-progress -O "$dest" "$url"
    fi
}

download_if_missing /workspace/models/diffusion_models/Wan21-14B-SCAIL-preview_fp8_e4m3fn_scaled_KJ.safetensors \
    "https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled/resolve/main/SCAIL/Wan21-14B-SCAIL-preview_fp8_e4m3fn_scaled_KJ.safetensors"

download_if_missing /workspace/models/vae/Wan2_1_VAE_bf16.safetensors \
    "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1_VAE_bf16.safetensors"

download_if_missing /workspace/models/loras/lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors \
    "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors"

download_if_missing /workspace/models/clip_vision/clip_vision_h.safetensors \
    "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors"

download_if_missing /workspace/models/nlf/nlf_l_multi_0.3.2.torchscript \
    "https://github.com/isarandi/nlf/releases/download/v0.3.2/nlf_l_multi_0.3.2.torchscript"

download_if_missing /workspace/models/detection/vitpose-l-wholebody.onnx \
    "https://huggingface.co/JunkyByte/easy_ViTPose/resolve/main/onnx/wholebody/vitpose-l-wholebody.onnx"

download_if_missing /workspace/models/detection/yolov10m.onnx \
    "https://huggingface.co/onnx-community/YOLOv10/resolve/main/yolov10m.onnx"

download_if_missing /workspace/models/text_encoders/umt5-xxl-enc-bf16.safetensors \
    "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/umt5-xxl-enc-bf16.safetensors"

# FlashVSR v1.1 model
if [ ! -d "/workspace/models/FlashVSR-v1.1" ] || [ -z "$(ls -A /workspace/models/FlashVSR-v1.1 2>/dev/null)" ]; then
    echo "  Downloading FlashVSR-v1.1..."
    python3 -c "from huggingface_hub import snapshot_download; snapshot_download(repo_id='JunhaoZhuang/FlashVSR-v1.1', local_dir='/workspace/models/FlashVSR-v1.1', local_dir_use_symlinks=False)"
else
    echo "  Already exists: /workspace/models/FlashVSR-v1.1"
fi

# -----------------------------------------------
# 6. Done
# -----------------------------------------------
echo "[6/6] Setup complete!"
echo ""
echo "Start ComfyUI with:"
echo "  cd /ComfyUI && python main.py --listen 0.0.0.0 --port 8188"
