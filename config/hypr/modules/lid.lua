local internal = "eDP-1"

local repair = "systemctl --user restart waybar; awww restore"

hl.bind(
	"switch:on:Lid Switch",
	hl.dsp.exec_cmd('hyprctl keyword monitor "' .. internal .. ', disable"; ' .. repair),
	{ locked = true }
)
hl.bind(
	"switch:off:Lid Switch",
	hl.dsp.exec_cmd('hyprctl keyword monitor "' .. internal .. ', preferred, auto, 1"; ' .. repair),
	{ locked = true }
)
