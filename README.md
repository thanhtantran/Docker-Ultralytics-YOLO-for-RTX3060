# Docker Ultralytics Run Container

__Ultralytics YOLO Training Pod__
__ultralytics-yolo-training__
__Installing `ultralytics==8.3.57`__

## Kiểm tra NVIDIA driver

```
# Kiểm tra GPU
nvidia-smi
```

Cài đặt NVIDIA Container Toolkit

```
# Thêm repository
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Cài đặt
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit

# Cấu hình Docker
sudo nvidia-ctk runtime configure --runtime=docker

# Restart Docker
sudo systemctl restart docker
```

## Test GPU trong Docker
```
# Test GPU
docker run --rm --gpus all nvidia/cuda:12.4.1-base-ubuntu22.04 nvidia-smi
```

# Chạy

```
# Build
docker build -t runpod-ultralytics-template:latest .

# Run with compose
docker compose up -d

# View logs
docker compose logs -f

# Check health
docker compose ps

# Stop gracefully
docker compose down
```


## What's inside

- Ultralytics (configurable version)
- JupyterLab (port 8888)
- File Browser (port 8080) — drag & drop your files

## Usage

1. Click deploy button
2. Pick a GPU
3. Upload dataset via File Browser
4. Train:
```python
from ultralytics import YOLO

model = YOLO('yolov8n.pt')
model.train(data='dataset.yaml', epochs=100)
```

## Config

Set `ULTRALYTICS_VERSION` env var to change version (default: `8.3.57`)

## License

MIT. Note that Ultralytics itself is AGPL-3.0.
# Docker-Ultralytics-YOLO-for-RTX3060
