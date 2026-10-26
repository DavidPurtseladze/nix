local config_home = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")
package.path = config_home .. "/hypr/?.lua;" .. config_home .. "/hypr/?/init.lua;" .. package.path

require("modules.env")
require("modules.monitors")
require("modules.input")
require("modules.cursor")
require("modules.xwayland")
require("modules.general")
require("modules.decoration")
require("modules.animation")
require("modules.dwindle")
require("modules.gestures")
require("modules.window_rules")
require("modules.layer_rules")
require("modules.binds")
require("modules.lid")
require("modules.autostart")

hl.on("hyprland.start", function()
	hl.exec_cmd(
		"dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE"
			.. " && systemctl --user stop hyprland-session.target"
			.. " && systemctl --user start hyprland-session.target"
	)
end)

hl.on("hyprland.shutdown", function()
	os.execute("systemctl --user stop hyprland-session.target && sleep 0.1")
end)
