#!/bin/bash
set -euo pipefail

# Example sysctl output:
# total = 2.00G  used = 512.00M  free = 1.50G  (encrypted)
swap_usage="$(sysctl -n vm.swapusage 2>/dev/null)"

used="$(printf '%s\n' "$swap_usage" | awk -F'used = ' '{print $2}' | awk '{print $1}')"

echo "$used"