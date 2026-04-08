FROM runpod/worker-comfyui:5.8.5-base

# Add network volume model paths
COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml

# Symlink FlashVSR model to network volume so it doesn't re-download
RUN ln -sf /runpod-volume/models/FlashVSR-v1.1 /comfyui/models/FlashVSR-v1.1

RUN pip install sageattention
RUN apt-get update && apt-get install -y gcc g++ && rm -rf /var/lib/apt/lists/*

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
