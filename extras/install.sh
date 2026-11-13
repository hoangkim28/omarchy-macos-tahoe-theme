#!/bin/bash
# Installs the optional macOS Tahoe extras. They only take effect while the
# macos-tahoe or macos-tahoe-light theme is active; every other theme keeps
# its own look.
#   - ~/.config/hypr/macos.lua      rounding, shadows, glass blur, motion, cursor
#   - theme-set hook                window buttons, menu bar, cursor, UI font
#   - bar snapshot                  the macOS-style menu bar layout
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
hypr="$HOME/.config/hypr"
snap="$HOME/.config/omarchy/macos-tahoe"

# 1. Hyprland look, loaded last so it wins over looknfeel.lua and toggles.
if [[ -f $hypr/macos.lua ]] && ! cmp -s "$here/macos.lua" "$hypr/macos.lua"; then
  cp "$hypr/macos.lua" "$hypr/macos.lua.bak.$(date +%s)"
fi
cp "$here/macos.lua" "$hypr/macos.lua"
if ! grep -q '^require("hypr.macos")' "$hypr/hyprland.lua"; then
  cp "$hypr/hyprland.lua" "$hypr/hyprland.lua.bak.$(date +%s)"
  printf '\n-- macOS Tahoe look. Keep this last: it only applies while a macos-tahoe theme is active.\nrequire("hypr.macos")\n' >>"$hypr/hyprland.lua"
fi

# 2. Theme-set hook.
omarchy hook install theme-set "$here/20-macos-tahoe-chrome"

# 3. Menu bar used while on macOS Tahoe (kept if you already have one).
mkdir -p "$snap"
[[ -f $snap/bar-macos.json ]] || cp "$here/bar-macos.json" "$snap/bar-macos.json"

hyprctl reload >/dev/null && hyprctl configerrors

# Apply now if a macOS Tahoe theme is already active.
current="$(cat "$HOME/.local/state/omarchy/current/theme.name" 2>/dev/null || true)"
omarchy hook theme-set "$current"

echo "macOS Tahoe extras installed."
echo "Optional packages for the full look: inter-font (pacman), whitesur-icon-theme and apple_cursor (AUR)."
