
# wget -P 'ComfyUI/models/checkpoints/' 'https://huggingface.co/cyberdelia/CyberRealisticPony/resolve/main/CyberRealisticPony_V65.safetensors'
# wget -P 'ComfyUI/models/embeddings/' 'https://civitai.com/api/download/models/972770?&token=edab4368b7ee13fbad066e4abeb72ba1' --content-disposition
# wget -P 'ComfyUI/models/checkpoints/' 'https://civitai.com/api/download/models/708635?&token=edab4368b7ee13fbad066e4abeb72ba1' --content-disposition


# wget -P 'ComfyUI/models/loras/' 'https://civitai.com/api/download/models/354128?&token=edab4368b7ee13fbad066e4abeb72ba1' --content-disposition
# wget -P 'ComfyUI/models/loras/' 'https://civitai.com/api/download/models/623811?&token=edab4368b7ee13fbad066e4abeb72ba1' --content-disposition
# wget -P 'ComfyUI/models/loras/' 'https://civitai.com/api/download/models/522995?&token=edab4368b7ee13fbad066e4abeb72ba1' --content-disposition
# wget -P 'ComfyUI/models/loras/'  https://huggingface.co/ByteDance/SDXL-Lightning/resolve/main/sdxl_lightning_2step_lora.safetensors
# wget -P 'ComfyUI/models/loras/' 'https://huggingface.co/h94/IP-Adapter-FaceID/resolve/main/ip-adapter-faceid-plusv2_sdxl_lora.safetensors'



# wget -P 'ComfyUI/models/ipadapter' 'https://huggingface.co/h94/IP-Adapter-FaceID/resolve/main/ip-adapter-faceid-plusv2_sdxl.bin'
# wget -P '.' 'https://huggingface.co/MonsterMMORPG/tools/resolve/main/antelopev2.zip'
# python -m zipfile -e ./antelopev2.zip  ComfyUI/models/insightface/models/antelopev2
# python3 -c "
# import zipfile
# import os

# zip_path = './antelopev2.zip'
# extract_path = 'ComfyUI/models/insightface/models/'

# # Create the target directory if it doesn't exist
# os.makedirs(extract_path, exist_ok=True)

# # Extract all files with progress output
# with zipfile.ZipFile(zip_path, 'r') as zip_ref:
#     for file in zip_ref.namelist():
#         print(f'Extracting {file}...')
#         zip_ref.extract(file, extract_path)
# "
# mkdir ComfyUI/models/clip_vision
# wget -O 'ComfyUI/models/clip_vision/CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors' 'https://huggingface.co/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors'

# cd /workspace/ComfyUI/custom_nodes
# git clone https://github.com/ltdrdata/ComfyUI-Manager.git
# cd /workspace/ComfyUI
# comfy node install comfyui-manager
# comfy node install efficiency-nodes-comfyui
# comfy node install comfyui-reactor-node

# cd /workspace/ComfyUI/custom_nodes
# git clone https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes.git
# git clone https://github.com/nonnonstop/comfyui-faster-loading.gitcd /workspace/ComfyUI/custom_nodes
# git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus.git
# git clone https://github.com/WASasquatch/was-node-suite-comfyui.git
# git clone https://github.com/liusida/ComfyUI-AutoCropFaces
# cd /workspace/ComfyUI
# echo DONE