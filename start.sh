#!/bin/bash
set -e

echo "============================================"
echo "  Ultralytics YOLO Training Pod"
echo "  Installing ultralytics==${ULTRALYTICS_VERSION}"
echo "============================================"

# Install ultralytics at runtime (user can override version via env var)
uv pip install --system "ultralytics==${ULTRALYTICS_VERSION}"

# Verify installation
python -c "from ultralytics import YOLO; print('✓ Ultralytics installed successfully')"

# Start File Browser
filebrowser -a 0.0.0.0 -p ${FILEBROWSER_PORT} -r /workspace --noauth &
FILEBROWSER_PID=$!
echo "✓ File Browser: port ${FILEBROWSER_PORT} (PID: $FILEBROWSER_PID)"

# Start JupyterLab with proxy-friendly settings
jupyter lab \
    --ip=0.0.0.0 \
    --port=${JUPYTER_PORT} \
    --no-browser \
    --allow-root \
    --ServerApp.token='' \
    --ServerApp.password='' \
    --ServerApp.allow_origin='*' \
    --ServerApp.allow_remote_access=True \
    --ServerApp.disable_check_xsrf=True \
    --ServerApp.terminals_enabled=True &
JUPYTER_PID=$!
echo "✓ JupyterLab: port ${JUPYTER_PORT} (PID: $JUPYTER_PID)"

echo "============================================"
echo "  ✓ Ready! Services are running"
echo "  - JupyterLab: http://localhost:${JUPYTER_PORT}"
echo "  - File Browser: http://localhost:${FILEBROWSER_PORT}"
echo "============================================"

# Graceful shutdown handler
cleanup() {
    echo "🛑 Shutting down services..."
    kill $FILEBROWSER_PID $JUPYTER_PID 2>/dev/null || true
    wait $FILEBROWSER_PID $JUPYTER_PID 2>/dev/null || true
    echo "✓ Shutdown complete"
    exit 0
}

trap cleanup SIGTERM SIGINT

# Keep container running and monitor processes
while kill -0 $FILEBROWSER_PID 2>/dev/null && kill -0 $JUPYTER_PID 2>/dev/null; do
    sleep 5
done

echo "⚠️  One or more services stopped unexpectedly"
cleanup