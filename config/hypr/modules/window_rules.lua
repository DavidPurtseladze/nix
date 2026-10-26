hl.window_rule({
	name = "kitty-opacity",
	match = { class = "^(kitty)$" },
	opacity = 0.9,
})

hl.window_rule({
	name = "chat-opacity",
	match = { class = "^(discord|vesktop|org.telegram.desktop)$" },
	opacity = "0.85 0.7 1",
})

hl.window_rule({
	name = "browser-opacity",
	match = { class = "^(zen-beta)$" },
	opacity = "0.9 0.7 1",
})

hl.window_rule({
	name = "float-pavucontrol",
	match = { class = "^(org.pulseaudio.pavucontrol)$" },
	float = true,
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.window_rule({
	name = "flameshot-overlay",
	match = { class = "^(flameshot)$" },
	float = true,
	move = "0 0",
	pin = true,
	opacity = "1.0 1.0 1.0",
	no_blur = true,
	rounding = 0,
	no_anim = true,
})
