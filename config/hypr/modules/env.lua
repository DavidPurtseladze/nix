local cursor_theme = "Bibata-Modern-Ice"
local cursor_size = "24"

hl.env("XCURSOR_THEME", cursor_theme)
hl.env("XCURSOR_SIZE", cursor_size)
hl.env("HYPRCURSOR_SIZE", cursor_size)

hl.env("QT_PLUGIN_PATH", "/run/current-system/sw/lib/qt-6/plugins")

hl.env("NIXOS_OZONE_WL", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
