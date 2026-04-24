#!/bin/bash
# Resolve hostname from ~/.ssh/config so no IPs are hardcoded here
host=$(ssh -G openclaw-tunnel 2>/dev/null | awk '/^hostname / {print $2}')

# Wait for the remote host to be reachable before attempting SSH (handles post-wake timing)
until ping -c 1 -W 3 "${host:-openclaw-tunnel}" >/dev/null 2>&1; do
    sleep 5
done

exec ssh -N \
    -o ExitOnForwardFailure=yes \
    -o ServerAliveInterval=30 \
    -o ServerAliveCountMax=3 \
    -o ConnectTimeout=15 \
    openclaw-tunnel
