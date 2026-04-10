#!/bin/bash
set -euo pipefail

cd ~/claudeclaw

echo "==> Pulling claudeclaw (main)..."
git pull origin main

echo "==> Pulling claudeclaw-slack (main)..."
git -C extensions/claudeclaw-slack pull origin main

echo "==> Building..."
npm run build

echo "==> Restarting service..."
launchctl kickstart -k "gui/$(id -u)/com.claudeclaw.claudeclaw"

echo "==> Done."
