# Use Dockur Windows as base (published on GHCR)
# Docs: https://github.com/dockur/windows
FROM ghcr.io/dockur/windows:latest

# --- Optional defaults (override at runtime with -e / --env) ---
ENV VERSION="10l" \
    RAM_SIZE="8G" \
    CPU_CORES="4" \
    DISK_SIZE="256G" \
    USERNAME="Docker" \
    PASSWORD="admin" \
    LANGUAGE="English" \
    REGION="en-US" \
    KEYBOARD="en-US"

# --- Optional: copy post-install automation ---
# Place your installer script at ./oem/install.bat (plus any assets)
# It will be copied into C:\\OEM and executed automatically at the end of setup.
COPY oem/ /oem/

# --- Volumes ---
# /storage holds the VM disks & state (bind/mount this on run)
# /data is shared to Windows as \\host.lan\Data
VOLUME ["/storage", "/data"]

# --- Network ports ---
# 8006: built‑in web viewer (for install)
# 3389: RDP (TCP+UDP)
EXPOSE 8006 3389/tcp 3389/udp

# No CMD/ENTRYPOINT override: we keep the image defaults from dockur/windows
# Build:    docker build -t my-windows .
# Run:      docker run --rm --name windows \
#             --device=/dev/kvm --device=/dev/net/tun --cap-add NET_ADMIN \
#             -p 8006:8006 -p 3389:3389/tcp -p 3389:3389/udp \
#             -v "$PWD/windows:/storage" -v "$PWD/shared:/data" \
#             -e VERSION=11 -e CPU_CORES=4 -e RAM_SIZE=8G \
#             my-windows
