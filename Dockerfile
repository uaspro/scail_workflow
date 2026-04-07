FROM runpod/worker-comfyui:5.5.1-base

# Install custom nodes
RUN cd /comfyui/custom_nodes && git clone https://github.com/kijai/ComfyUI-WanVideoWrapper
RUN cd /comfyui/custom_nodes && git clone https://github.com/kijai/ComfyUI-KJNodes
RUN cd /comfyui/custom_nodes && git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite
RUN cd /comfyui/custom_nodes && git clone https://github.com/kijai/ComfyUI-Florence2
RUN cd /comfyui/custom_nodes && git clone https://github.com/kijai/ComfyUI-GIMM-VFI
RUN cd /comfyui/custom_nodes && git clone https://github.com/lihaoyun6/ComfyUI-FlashVSR_Ultra_Fast

# Install Python dependencies
RUN cd /comfyui/custom_nodes/ComfyUI-WanVideoWrapper && pip install -r requirements.txt
RUN cd /comfyui/custom_nodes/ComfyUI-KJNodes && pip install -r requirements.txt
RUN cd /comfyui/custom_nodes/ComfyUI-VideoHelperSuite && pip install -r requirements.txt
RUN cd /comfyui/custom_nodes/ComfyUI-Florence2 && pip install -r requirements.txt
RUN cd /comfyui/custom_nodes/ComfyUI-GIMM-VFI && pip install -r requirements.txt
RUN cd /comfyui/custom_nodes/ComfyUI-FlashVSR_Ultra_Fast && pip install -r requirements.txt

# download models into comfyui
RUN comfy model download --url https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled/resolve/main/SCAIL/Wan21-14B-SCAIL-preview_fp8_e4m3fn_scaled_KJ.safetensors --relative-path models/diffusion_models --filename Wan21-14B-SCAIL-preview_fp8_e4m3fn_scaled_KJ.safetensors
RUN comfy model download --url https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1_VAE_bf16.safetensors --relative-path models/vae --filename Wan2_1_VAE_bf16.safetensors
RUN comfy model download --url https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors --relative-path models/loras --filename lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors
RUN comfy model download --url https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors --relative-path models/clip_vision --filename clip_vision_h.safetensors
RUN comfy model download --url https://github.com/isarandi/nlf/releases/download/v0.3.2/nlf_l_multi_0.3.2.torchscript --relative-path models/other --filename nlf_l_multi_0.3.2.torchscript
RUN comfy model download --url https://huggingface.co/JunkyByte/easy_ViTPose/resolve/main/onnx/wholebody/vitpose-l-wholebody.onnx --relative-path models/detection --filename vitpose-l-wholebody.onnx
RUN comfy model download --url https://huggingface.co/onnx-community/YOLOv10/resolve/main/yolov10m.onnx --relative-path models/detection --filename yolov10m.onnx
RUN comfy model download --url https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/umt5-xxl-enc-bf16.safetensors --relative-path models/text_encoders --filename umt5-xxl-enc-bf16.safetensors
# RUN # Could not find URL for gimmvfi_r_arb_lpips_fp32.safetensors

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/
