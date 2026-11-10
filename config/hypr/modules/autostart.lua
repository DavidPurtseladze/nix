local home = os.getenv("HOME")
local wallpaper = home .. "/.config/assets/wallpapers/purple-tree.jpg"

hl.on("hyprland.start", function()
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("wl-clip-persist --clipboard regular")
	hl.exec_cmd("sleep 1 && awww img " .. wallpaper)
end)
