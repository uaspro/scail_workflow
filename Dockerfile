FROM runpod/worker-comfyui:5.8.5-base

# Add network volume model paths
RUN echo -e "\nrunpod_volume:\n  base_path: /runpod-volume/models/\n  diffusion_models: diffusion_models/\ntext_encoders: text_encoders/\n  detection: detection/\n  nlf: nlf/" >> /comfyui/extra_model_paths.yaml

# Install custom nodes
RUN cd /comfyui/custom_nodes && git clone https://github.com/kijai/ComfyUI-WanVideoWrapper
RUN cd /comfyui/custom_nodes && git clone https://github.com/kijai/ComfyUI-KJNodes
RUN cd /comfyui/custom_nodes && git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite
RUN cd /comfyui/custom_nodes && git clone https://github.com/kijai/ComfyUI-Florence2
RUN cd /comfyui/custom_nodes && git clone https://github.com/kijai/ComfyUI-GIMM-VFI
RUN cd /comfyui/custom_nodes && git clone https://github.com/lihaoyun6/ComfyUI-FlashVSR_Ultra_Fast
RUN cd /comfyui/custom_nodes && git clone https://github.com/kijai/ComfyUI-SCAIL-Pose
RUN cd /comfyui/custom_nodes && git clone https://github.com/kijai/ComfyUI-WanAnimatePreprocess

# Install Python dependencies
RUN cd /comfyui/custom_nodes/ComfyUI-WanVideoWrapper && pip install -r requirements.txt
RUN cd /comfyui/custom_nodes/ComfyUI-KJNodes && pip install -r requirements.txt
RUN cd /comfyui/custom_nodes/ComfyUI-VideoHelperSuite && pip install -r requirements.txt
RUN cd /comfyui/custom_nodes/ComfyUI-Florence2 && pip install -r requirements.txt
RUN cd /comfyui/custom_nodes/ComfyUI-GIMM-VFI && pip install -r requirements.txt
RUN cd /comfyui/custom_nodes/ComfyUI-FlashVSR_Ultra_Fast && pip install -r requirements.txt
RUN cd /comfyui/custom_nodes/ComfyUI-SCAIL-Pose && pip install -r requirements.txt
RUN cd /comfyui/custom_nodes/ComfyUI-WanAnimatePreprocess && pip install -r requirements.txt

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
