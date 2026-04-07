# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.1-base

# install custom nodes into comfyui (first node with --mode remote to fetch updated cache)
# The workflow lists only unknown_registry custom nodes without aux_id (no registry IDs provided).
# These could not be automatically resolved or installed. Please provide either the ComfyUI registry IDs
# for these packages or GitHub repo auxiliary IDs (aux_id) so they can be installed or cloned.
# Missing/unresolved custom nodes from workflow (no aux_id provided):
# - WanVideoModelLoader
# - WanVideoDecode
# - WanVideoTorchCompileSettings
# - WanVideoVAELoader
# - WanVideoBlockSwap
# - WanVideoLoraSelect
# - WanVideoSetLoRAs
# - WanVideoSetBlockSwap
# - WanVideoEmptyEmbeds
# - ImageResizeKJv2
# - VHS_LoadVideo
# - ImageResizeKJv2
# - VHS_VideoCombine
# - VHS_VideoCombine
# - INTConstant
# - INTConstant
# - FloatConstant
# - ImageConcatMulti
# - GetImageSizeAndCount
# - WanVideoAddSCAILPoseEmbeds
# - CLIPVisionLoader
# - WanVideoClipVisionEncode
# - ImageConcatMulti
# - NLFPredict
# - DownloadAndLoadNLFModel
# - WanVideoSamplerv2
# - WanVideoSchedulerv2
# - WanVideoAddSCAILReferenceEmbeds
# - WanVideoSamplerExtraArgs
# - WanVideoContextOptions
# - RenderNLFPoses
# - PoseDetectionVitPoseToDWPose
# - OnnxDetectionModelLoader
# - PoseDetectionVitPoseToDWPose
# - WanVideoTextEncodeCached
# - SimpleCalculatorKJ
# - SimpleCalculatorKJ
# - DownloadAndLoadGIMMVFIModel
# - GIMMVFI_interpolate
# - FlashVSRInitPipe
# - FlashVSRNodeAdv

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
