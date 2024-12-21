# Stage 1: Base image with common dependencies
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04 as base
# FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04 as base
# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    PIP_PREFER_BINARY=1 \
    PYTHONUNBUFFERED=1

# Install Python, git, wget, and necessary tools in one step and clean up
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    git \
    wget

# Clean up to reduce image size
RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*


# Clone ComfyUI and custom nodes
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /ComfyUI && \
    cd /ComfyUI/custom_nodes && \
    git clone https://github.com/jags111/efficiency-nodes-comfyui && \
    git clone https://github.com/nonnonstop/comfyui-faster-loading.git && \
    git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus.git && \
    git clone https://github.com/liusida/ComfyUI-AutoCropFaces.git && \
    git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git && \
    git clone https://github.com/cubiq/ComfyUI_essentials.git && \
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git

# Install ComfyUI dependencies
RUN pip3 install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 && \
    pip3 install --no-cache-dir -r /ComfyUI/requirements.txt

# Install additional dependencies
RUN pip3 install --no-cache-dir runpod requests
# ADD src/extra_model_paths.yaml /ComfyUI
# Add start scripts and handler
ADD src/start.sh src/rp_handler.py /
RUN chmod +x /start.sh

# Stage 2: Download models and install additional dependencies
FROM base as downloader

# Install additional Python packages and libraries
RUN pip3 install --no-cache-dir \
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
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg libsm6 libxext6 && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Run manual installation script for Impact Pack
WORKDIR /ComfyUI/custom_nodes/ComfyUI-Impact-Pack
RUN python3 install-manual.py

# Download and extract buffalo_l.zip
RUN mkdir -p /ComfyUI/models/insightface/models/buffalo_l && \
    wget -q -O /tmp/buffalo_l.zip https://github.com/deepinsight/insightface/releases/download/v0.7/buffalo_l.zip && \
    python3 -c "import zipfile; zip_ref = zipfile.ZipFile('/tmp/buffalo_l.zip', 'r'); zip_ref.extractall('/ComfyUI/models/insightface/models/buffalo_l'); zip_ref.close()" && \
    rm -rf /tmp/buffalo_l.zip

# Download other models using get_models.sh
COPY src/get_models.sh /get_models.sh
RUN /bin/bash /get_models.sh && rm /get_models.sh

# Final setup
CMD ["/start.sh"]
