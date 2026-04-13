#!/bin/bash
set -euo pipefail

# Resolve to the repo root (where this script lives)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "==> Pulling claudeclaw (main)..."
git pull origin main

echo "==> Pulling claudeclaw-slack (main)..."
git -C extensions/claudeclaw-slack pull origin main

echo "==> Building..."
npm run build

echo "==> Restarting service..."
# Auto-detect the launchd plist name
PLIST=$(ls ~/Library/LaunchAgents/*claw* 2>/dev/null | head -1 || true)
if [ -n "$PLIST" ]; then
  SERVICE=$(defaults read "$PLIST" Label)
  launchctl kickstart -k "gui/$(id -u)/$SERVICE"
else
  echo "No launchd plist found. Restart the service manually."
fi

echo "==> Done."
