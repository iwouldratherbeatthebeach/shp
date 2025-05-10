#!/usr/bin/env bash
#
# build_nav.sh
# Usage: ./build_nav.sh <app_root> [nav_color] [landing_dashboard]
#
#   <app_root>          path to your Splunk app (containing default/data/ui/views/)
#   [nav_color]         (optional) toolbar color, default="#E32819"
#   [landing_dashboard] (optional) dashboard name to mark default="true"
#

set -e

APP_ROOT=${1:?"Missing app_root; usage: $0 <app_root> [nav_color] [landing_dashboard]"}
NAV_COLOR=${2:-"#E32819"}
LANDING=${3:-}

VIEWS_DIR="$APP_ROOT/default/data/ui/views"
NAV_DIR="$APP_ROOT/default/data/ui/nav"
OUT_FILE="$NAV_DIR/default.xml"

mkdir -p "$NAV_DIR"

first=true
{
  echo '<?xml version="1.0" encoding="UTF-8"?>'
  echo "<nav color=\"$NAV_COLOR\">"
  for f in "$VIEWS_DIR"/*.xml; do
    name=$(basename "$f" .xml)
    if [[ -n "$LANDING" ]]; then
      default=$([[ "$name" == "$LANDING" ]] && echo "true" || echo "false")
    else
      if $first; then
        default="true"
        first=false
      else
        default="false"
      fi
    fi
    printf '  <view name="%s" default="%s"/>\n' "$name" "$default"
  done
  echo "</nav>"
} > "$OUT_FILE"

echo "Wrote $OUT_FILE"

