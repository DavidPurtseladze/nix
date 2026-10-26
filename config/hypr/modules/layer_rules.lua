hl.layer_rule({
	name = "waybar-blur",
	match = { namespace = "waybar" },
	blur = true,
	ignore_alpha = 0.5,
})

hl.layer_rule({
	name = "panels-blur",
	match = { namespace = "logout_dialog|swaync-control-center" },
	blur = true,
})
