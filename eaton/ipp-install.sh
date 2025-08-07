#!/bin/bash

set -e  # Exit immediately on error

#############################################
# Configuration section (easy to modify)
#############################################

# --- Locate the IPP installer (.deb) file in /root ---
DEB_FILE=$(ls /root/ipp-linux*.deb 2>/dev/null | head -n1)
IPP_USER="eaton-ipp"
IPP_DIR="/usr/local/eaton/IntelligentPowerProtector"
SERVICE_NAME="eaton-ipp"
SUDOERS_FILE="/etc/sudoers.d/$IPP_USER"
SHUTDOWN_SCRIPT="$IPP_DIR/configs/actions/shutdown.sh"
LOGFILE="/var/log/eaton_shutdown.log"
WEB_PORT=4680

#############################################
# Install the IPP .deb package
#############################################

if [[ ! -f "$DEB_FILE" ]]; then
  echo "ERROR: Could not find IPP .deb file at $DEB_FILE"
  exit 1
fi

echo "Installing Eaton IPP from $DEB_FILE..."
apt install -y "$DEB_FILE"

#############################################
# Create service user and set permissions
#############################################

echo "Ensuring service user '$IPP_USER' exists with proper permissions..."

# Create dedicated service user if missing
if ! id "$IPP_USER" &>/dev/null; then
  useradd "$IPP_USER" -r -s /bin/false
  passwd -d "$IPP_USER"
fi

# Set ownership of IPP directory
chown -R "$IPP_USER" "$IPP_DIR"

#############################################
# Restart and enable the service
#############################################

echo "Reloading systemd and restarting $SERVICE_NAME service..."
systemctl daemon-reload
systemctl restart "$SERVICE_NAME"
systemctl enable "$SERVICE_NAME"

echo "Waiting 3 seconds for $SERVICE_NAME to initialize..."
sleep 3
systemctl status "$SERVICE_NAME" --no-pager || true

#############################################
# Create shutdown script triggered by IPP
#############################################

echo "Creating shutdown script at $SHUTDOWN_SCRIPT..."

mkdir -p "$(dirname "$SHUTDOWN_SCRIPT")"

cat > "$SHUTDOWN_SCRIPT" << EOF
#!/bin/bash

# Graceful Proxmox shutdown initiated by Eaton IPP
echo "\$(date) - Eaton shutdown triggered" >> "$LOGFILE"
echo "\$(date) - Shutting down host" >> "$LOGFILE"
logger -t $SERVICE_NAME "Eaton IPP initiated host shutdown"
shutdown -h now
EOF

chmod +x "$SHUTDOWN_SCRIPT"

#############################################
# Grant sudo access for shutdown script
#############################################

if [ ! -f "$SUDOERS_FILE" ]; then
    echo "Creating sudoers rule for $IPP_USER"
    cat <<EOF > "$SUDOERS_FILE"
# Allow '$IPP_USER' to execute shutdown without password
# Required by Eaton Intelligent Power Protector to shut down host safely
$IPP_USER ALL=(ALL) NOPASSWD: /sbin/shutdown, $SHUTDOWN_SCRIPT
EOF
    chmod 440 "$SUDOERS_FILE"
else
    echo "Sudoers rule for $IPP_USER already exists at $SUDOERS_FILE"
fi

#############################################
# Display web interface access info
#############################################

echo "=== Installation Complete ==="
echo "Web interfaces available on:"
for ip in $(hostname -I); do
    echo "  → https://$ip:$WEB_PORT"
done
echo "Default Username: admin"
echo "Default Password: admin"