-- macOS Tahoe look. Loaded last (after toggles) so it wins over everything,
-- but ONLY while the "macos-tahoe" or "macos-tahoe-light" theme is active.
-- Every other theme keeps its own look plus looknfeel.lua.

do
  local state = os.getenv("XDG_STATE_HOME")
  if state == nil or state == "" then state = os.getenv("HOME") .. "/.local/state" end
  local f = io.open(state .. "/omarchy/current/theme.name", "r")
  local theme = f and f:read("*l") or ""
  if f then f:close() end
  if theme ~= "macos-tahoe" and theme ~= "macos-tahoe-light" then
    -- Environment variables outlive a reload, so clear the ones set below;
    -- an empty OMARCHY_MENU_FONT makes the menu use the normal font again.
    hl.env("OMARCHY_MENU_FONT", "")
    return
  end
end

hl.config({
  general = {
    gaps_in = 6,
    gaps_out = 12,
    border_size = 1,
  },

  decoration = {
    -- Apple-style continuous corners (squircle).
    rounding = 14,
    rounding_power = 4,

    active_opacity = 1.0,
    inactive_opacity = 1.0,
    dim_inactive = false,

    -- Big, soft window shadow like macOS.
    shadow = {
      enabled = true,
      range = 36,
      render_power = 3,
      offset = { 0, 10 },
      color = "rgba(00000070)",
      color_inactive = "rgba(00000040)",
    },

    -- Liquid Glass frost for menus, panels, notifications.
    blur = {
      enabled = true,
      size = 14,
      passes = 3,
      new_optimizations = true,
      xray = false,
      contrast = 1.0,
      brightness = 0.95,
      noise = 0.015,
      vibrancy = 0.25,
      vibrancy_darkness = 0.2,
      popups = true,
      special = true,
    },
  },

  animations = {
    enabled = true,
  },
})

-- macOS-like motion: quick, damped, no bounce.
hl.curve("macSpring", { type = "bezier", points = { { 0.32, 0.72 }, { 0, 1 } } })
hl.curve("macOut", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })
hl.curve("macIn", { type = "bezier", points = { { 0.4, 0 }, { 1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 6, bezier = "macOut" })
hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "macSpring" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3.5, bezier = "macSpring", style = "popin 90%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.2, bezier = "macIn", style = "popin 92%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "macSpring" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "macOut" })
hl.animation({ leaf = "border", enabled = true, speed = 3, bezier = "macOut" })
-- Spaces slide sideways, like a three-finger swipe on macOS.
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "macSpring", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "macSpring", style = "slidevert" })
hl.animation({ leaf = "layers", enabled = true, speed = 3, bezier = "macOut", style = "fade" })

-- Rounded, shadowed windows whether tiled or floating (overrides looknfeel).
o.window({ float = false }, { rounding = 14 })
o.window({ float = true }, { rounding = 14 })

-- Frosted glass behind every translucent shell surface (bar popouts,
-- Spotlight/launcher, notifications, OSD, polkit, clipboard, emoji picker).
hl.layer_rule({
  match = { namespace = "^(omarchy-bar|omarchy-menu|omarchy-notifications|omarchy-osd|omarchy-polkit|omarchy-reminders|omarchy-clipboard|omarchy-emojis|omarchy-keyboard-panel|omarchy-network-qr)$" },
  blur = true,
  ignore_alpha = 0.3,
})

-- Spotlight-style font for menus and the launcher (falls back if missing).
hl.env("OMARCHY_MENU_FONT", "Inter")

-- macOS cursor for apps launched while a macOS theme is active
-- (the theme-set hook also switches the live cursor and GTK setting).
hl.env("XCURSOR_THEME", "macOS")
hl.env("XCURSOR_SIZE", "24")
