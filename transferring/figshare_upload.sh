#!/usr/bin/env bash
# figshare_upload.sh — Upload files from the current directory to Figshare via FTPS
# Run this script from the directory containing the files you want to upload.

set -euo pipefail

FTPS_HOST="ftps.figshare.com"

echo "=================================================="
echo " Figshare FTPS Uploader"
echo "=================================================="
echo ""

# --- Prerequisites check ---
if ! command -v lftp &>/dev/null; then
    echo "ERROR: 'lftp' is not installed."
    echo ""
    echo "Install it with:"
    echo "  Debian/Ubuntu:  sudo apt-get install lftp"
    echo "  CentOS/RHEL:    sudo yum install lftp"
    echo "  macOS:          brew install lftp"
    exit 1
fi

# --- Credentials ---
echo "Do you already have Figshare FTP credentials? (y/n)"
read -r has_creds

if [[ "$has_creds" != "y" && "$has_creds" != "Y" ]]; then
    echo ""
    echo "To generate your Figshare FTP credentials:"
    echo ""
    echo "  1. Log into your Figshare account at https://figshare.com"
    echo "  2. Click your profile picture (top right) → select 'Integrations'"
    echo "  3. Scroll down to the 'FTP' section"
    echo "  4. Note your FTP Username (usually a numeric ID)"
    echo "  5. Click 'Generate Password' and copy the password"
    echo ""
    echo "Then re-run this script."
    exit 0
fi

echo ""
echo "Enter your Figshare FTP username:"
read -r FTP_USER

echo "Enter your Figshare FTP password (input hidden):"
read -rs FTP_PASS
echo ""

# --- Dataset title ---
echo "Enter the dataset title (this becomes the Figshare item title):"
read -r DATASET_TITLE

if [[ -z "$DATASET_TITLE" ]]; then
    echo "ERROR: Dataset title cannot be empty."
    exit 1
fi

# --- README reminder ---
echo ""
if [[ -f "README.md" || -f "README" || -f "readme.md" || -f "readme" ]]; then
    echo "NOTE: A README file was found in this directory."
    echo "      Its contents can serve as the item description when you publish on Figshare."
fi

# --- File listing and confirmation ---
echo ""
echo "Files to be uploaded from: $(pwd)"
echo "--------------------------------------------------"
ls -lh --color=never 2>/dev/null || ls -lh
echo "--------------------------------------------------"
echo ""
echo "Proceed with uploading these files to Figshare under the title"
echo "  \"$DATASET_TITLE\"? (y/n)"
read -r confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Upload cancelled."
    exit 0
fi

# --- Upload via lftp ---
echo ""
echo "Connecting to $FTPS_HOST ..."
echo "(This may take a while for large datasets. The transfer is resumable if interrupted.)"
echo ""

LOCAL_DIR="$(pwd)"
SCRIPT_NAME="$(basename "$0")"

lftp -u "$FTP_USER","$FTP_PASS" "$FTPS_HOST" <<EOF
set ftp:ssl-force true
set ftp:ssl-protect-data true
set ssl:verify-certificate no
cd data
mkdir -p "$DATASET_TITLE"
cd "$DATASET_TITLE"
mirror -R -c --exclude "$SCRIPT_NAME" "$LOCAL_DIR/" .
bye
EOF

# --- Done ---
echo ""
echo "=================================================="
echo " Upload complete!"
echo "=================================================="
echo ""
echo "Next steps:"
echo "  1. Wait for Figshare to process your files (may take several minutes)."
echo "     When done, a 'processed_files_log.txt' will appear in the FTP folder."
echo "  2. Go to https://figshare.com → 'My data' to find the draft item"
echo "     titled \"$DATASET_TITLE\"."
echo "  3. Fill in the metadata (authors, description, categories, license)"
echo "     and click Publish."
