#!/bin/sh
# 
# Syncs the content of the current directory with a remote server using rsync
# via SSH.
#
# Usage: csync.sh <user@remoteserver> <remote path where directory will be synced>
#
# Example: csync.sh nemmen@alphacrucis pluto

# check if there were command-line arguments
if [ $# -eq 0 ]; then
    echo "Usage: "
    echo "  csync.sh <user@remoteserver> <remote path where directory will be synced> "
    exit 1
fi

rsync -va -e ssh --progress --delete . $1:$2

