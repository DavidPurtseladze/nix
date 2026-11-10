local mod = "SUPER"
local home = os.getenv("HOME")

-- Applications
hl.bind(mod .. " + T", hl.dsp.exec_cmd("kitty -e zsh -c 'fastfetch; exec zsh'"))
hl.bind(mod .. " + E", hl.dsp.exec_cmd("thunar"))
hl.bind(mod .. " + B", hl.dsp.exec_cmd("zen-beta"))

-- Launchers and session
hl.bind(mod .. " + Space", hl.dsp.exec_cmd("launcher toggle"))
hl.bind(mod .. " + Escape", hl.dsp.exec_cmd("wlogout -p layer-shell"))
hl.bind(mod .. " + L", hl.dsp.exec_cmd("flock -n /tmp/qylock.lock qylock-lock"))

-- Tools
hl.bind(mod .. " + R", hl.dsp.exec_cmd("wallpaper-ui"))
hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("theme-ui"))
hl.bind(mod .. " + V", hl.dsp.exec_cmd("clipboard-history"))
hl.bind(mod .. " + SHIFT + I", hl.dsp.exec_cmd("caffeine toggle"))
hl.bind(mod .. " + SHIFT + N", hl.dsp.exec_cmd("night-mode toggle"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("flameshot-monitor"))
hl.bind("Print", hl.dsp.exec_cmd("flameshot full -c -p " .. home .. "/Pictures/Screenshots"))

-- Window management
hl.bind(mod .. " + W", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + J", hl.dsp.layout("togglesplit"))

-- Workspaces
for i = 1, 10 do
	local key = (i == 10) and 0 or i
	hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Focus and movement
for _, d in ipairs({ "Left", "Right", "Up", "Down" }) do
	hl.bind(mod .. " + " .. d, hl.dsp.focus({ direction = d:lower() }))
	hl.bind(mod .. " + CONTROL + " .. d, hl.dsp.window.move({ direction = d:lower() }))
end

-- Hardware keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("volume up"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("volume down"), { repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightness up"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightness down"), { repeating = true })

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("volume mute"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Resize
for _, r in ipairs({ { "Left", -50, 0 }, { "Right", 50, 0 }, { "Up", 0, -50 }, { "Down", 0, 50 } }) do
	local key, x, y = r[1], r[2], r[3]
	hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.resize({ x = x, y = y, relative = true }), { repeating = true })
end

-- Mouse
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
