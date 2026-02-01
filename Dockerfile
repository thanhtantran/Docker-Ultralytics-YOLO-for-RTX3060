FROM runpod/pytorch:2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04

LABEL maintainer="thanhtan.tran@gmail.com"
LABEL description="Ultralytics YOLO Training Template with JupyterLab & File Browser"

ENV DEBIAN_FRONTEND=noninteractive
ENV JUPYTER_PORT=8888
ENV FILEBROWSER_PORT=8080
ENV ULTRALYTICS_VERSION=8.3.57

# Install system deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1-mesa-glx \
    libglib2.0-0 \
    curl \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install uv (fix PATH)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.cargo/bin:/root/.local/bin:$PATH"

# Install File Browser
RUN curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

# Install base packages
RUN uv pip install --system \
    jupyterlab \
    ipywidgets \
    albumentations \
    matplotlib \
    seaborn \
    pandas

# Verify ultralytics can be installed
#RUN uv pip install --system ultralytics && \
#    python -c "from ultralytics import YOLO; print('Ultralytics OK')" && \
#    uv pip uninstall --system ultralytics

# Copy and set permissions
COPY start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /workspace

EXPOSE 8888 8080

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:${JUPYTER_PORT}/api || exit 1

CMD ["/start.sh"]