local internal = "eDP-1"

local function repair()
	hl.exec_cmd("systemctl --user restart waybar")
	hl.exec_cmd("awww restore")
end

hl.bind("switch:on:Lid Switch", function()
	hl.monitor({ output = internal, disabled = true })
	hl.exec_cmd("flock -n /tmp/qylock.lock qylock-lock")
	repair()
end, { locked = true })

hl.bind("switch:off:Lid Switch", function()
	hl.monitor({ output = internal, disabled = false })
	repair()
end, { locked = true })
