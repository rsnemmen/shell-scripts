#!/bin/bash

# Usage: ./steam_downloader.sh <INSTALL_DIR> <APP_ID> <USERNAME>
#
# Example: ./steam_downloader.sh "/Users/yourusername/Desktop/hl2" 220 yoursteamusername

# Assign arguments
INSTALL_DIR="$1"
APP_ID="$2"
USERNAME="$3"

# Basic argument validation
if [ -z "$INSTALL_DIR" ] || [ -z "$APP_ID" ] || [ -z "$USERNAME" ]; then
    echo "Usage: $0 <INSTALL_DIR> <APP_ID> <USERNAME>"
    echo "All arguments are required."
    exit 1
fi

# Create the install directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    mkdir -p "$INSTALL_DIR"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create directory $INSTALL_DIR. Check permissions."
        exit 1
    fi
    echo "Created directory: $INSTALL_DIR"
fi

# Run SteamCMD with the commands
echo "Starting download for App ID $APP_ID to $INSTALL_DIR..."
steamcmd +@sSteamCmdForcePlatformType windows +login "$USERNAME" +force_install_dir "$INSTALL_DIR" +app_update "$APP_ID" validate +quit

# Check if the command succeeded
if [ $? -eq 0 ]; then
    echo "Download completed successfully. Files should be in: $INSTALL_DIR"
else
    echo "Error: Download failed. Check the output above for details (e.g., login issues or no subscription)."
fi