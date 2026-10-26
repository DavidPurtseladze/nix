local theme = require("modules.palette")

hl.config({
	general = {
		layout = "dwindle",

		gaps_in = 4,
		gaps_out = 8,
		border_size = 2,

		resize_on_border = false,
		allow_tearing = false,

		["col.active_border"] = theme.gradient("base0E", "base0D", "ee", 45),
		["col.inactive_border"] = theme.rgba("base02", "aa"),
	},
})
