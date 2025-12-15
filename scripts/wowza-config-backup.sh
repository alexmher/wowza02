#!/usr/bin/env bash
set -euo pipefail

WOWZA="/usr/local/WowzaStreamingEngine-4.9.0+3"
REPO="/opt/wowza-config-git"
BRANCH="main"

cd "$REPO"

# ---- SYNC DIRECTORIES ----
# scripts
rsync -a --delete \
  --exclude='logs' \
  --exclude='*.log' \
  "/root/scripts/"  "$REPO/scripts/"

# conf
rsync -a --delete \
  --exclude='logs' \
  --exclude='*.log' \
  "$WOWZA/conf/"  "$REPO/conf/"

# applications
rsync -a --delete \
  --exclude='logs' \
  --exclude='*.log' \
  --exclude='.gitkeep' \
  "$WOWZA/applications/"  "$REPO/applications/"

# transcoder
rsync -a --delete \
  --exclude='logs' \
  --exclude='*.log' \
  "$WOWZA/transcoder/"  "$REPO/transcoder/"

# ---- SYNC CUSTOM JAR ----
mkdir -p "$REPO/lib"
if [[ -f "$WOWZA/lib/timecode.jar" ]]; then
    cp "$WOWZA/lib/timecode.jar" "$REPO/lib/timecode.jar"
fi
if [[ -f "$WOWZA/lib/wms-server.jar" ]]; then
    cp "$WOWZA/lib/wms-server.jar" "$REPO/lib/wms-server.jar"
fi
# ---- GIT COMMIT IF CHANGED ----
if [[ -n "$(git status --porcelain)" ]]; then
    NOW="$(date '+%F %T')"
    git add .
    git commit -m "Auto backup Wowza config $NOW"
    git push origin "$BRANCH"
fi
