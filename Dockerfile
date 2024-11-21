# Stage 1: Base image with common dependencies
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04 as base

# Prevents prompts from packages asking for user input during installation
ENV DEBIAN_FRONTEND=noninteractive
# Prefer binary wheels over source distributions for faster pip installations
ENV PIP_PREFER_BINARY=1
# Ensures output from python is printed immediately to the terminal without buffering
ENV PYTHONUNBUFFERED=1 

# Install Python, git and other necessary tools
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    git \
    wget

# Clean up to reduce image size
RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Clone ComfyUI repository
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /ComfyUI

# Change working directory to ComfyUI
WORKDIR /ComfyUI/custom_nodes
RUN git clone https://github.com/jags111/efficiency-nodes-comfyui
RUN git clone https://github.com/nonnonstop/comfyui-faster-loading.git
RUN git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus.git
RUN git clone https://github.com/liusida/ComfyUI-AutoCropFaces.git
RUN git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
RUN git clone https://github.com/cubiq/ComfyUI_essentials.git
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git
### pip install requirements for impact-pact! I just did python install-manual.py within the custom_node/impact_pact
WORKDIR /ComfyUI/custom_nodes/ComfyUI-Impact-Pack
RUN python3 install-manual.py
RUN wget -P 'ComfyUI/models/checkpoints/' 'https://huggingface.co/cyberdelia/CyberRealisticPony/resolve/main/CyberRealisticPony_V65.safetensors'

# Downloading /ComfyUI/models/insightface/models/buffalo_l.zip from https://github.com/deepinsight/insightface/releases/download/v0.7/buffalo_l.zip

WORKDIR /ComfyUI
# Install ComfyUI dependencies
RUN pip3 install --upgrade --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 \
&& pip3 install --upgrade -r requirements.txt

# Install runpod
RUN pip3 install runpod requests

# Support for the network volume
ADD src/extra_model_paths.yaml /ComfyUI

# Go back to the root
WORKDIR /

# Add the start and the handler
ADD src/start.sh src/rp_handler.py  ./
RUN chmod +x /start.sh
# Stage 2: Download models
FROM base as downloader

ARG HUGGINGFACE_ACCESS_TOKEN
ARG MODEL_TYPE

# this should be auto installed by comfyUI but since we are using a network-mounted comfyui needs to be installed here
RUN pip install \
    segment-anything \
    scikit-image \
    piexif \
    transformers \
    opencv-python-headless \
    GitPython \
    "scipy>=1.11.4" \
    "numpy<2" \
    dill \
    matplotlib \
    ultralytics \
    "insightface==0.7.3" \
    onnxruntime
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y



# Change working directory to ComfyUI
# WORKDIR /ComfyUI
COPY setup.sh /setup.sh
RUN /bin/bash /setup.sh && \
    rm /setup.sh

# Start the container
CMD /start.sh