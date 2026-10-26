local theme = require("modules.palette")

hl.config({
	decoration = {
		rounding = 8,
		rounding_power = 2,

		active_opacity = 1.0,
		inactive_opacity = 0.8,

		shadow = {
			enabled = false,
			range = 4,
			render_power = 3,
			color = theme.rgba("base00", "ee"),
		},

		blur = {
			enabled = true,
			size = 5,
			passes = 3,

			ignore_opacity = true,
			new_optimizations = true,
			special = false,
			popups = true,
			xray = true,

			vibrancy = 0.1696,
		},
	},
})
