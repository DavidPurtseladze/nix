local defaults = {
	base00 = "#1e1e2e",
	base01 = "#313244",
	base02 = "#45475a",
	base03 = "#6c7086",
	base04 = "#a6adc8",
	base05 = "#cdd6f4",
	base06 = "#f5e0dc",
	base07 = "#b4befe",
	base08 = "#f38ba8",
	base09 = "#fab387",
	base0A = "#f9e2af",
	base0B = "#a6e3a1",
	base0C = "#94e2d5",
	base0D = "#89b4fa",
	base0E = "#f5c2e7",
	base0F = "#94e2d5",
}

local function state_dir()
	local state = os.getenv("XDG_STATE_HOME")
	if state == nil or state == "" then
		state = (os.getenv("HOME") or "") .. "/.local/state"
	end
	return state
end

local function load()
	local colors = {}
	for key, value in pairs(defaults) do
		colors[key] = value
	end

	local chunk = loadfile(state_dir() .. "/theme/palette.lua")
	if chunk == nil then
		return colors
	end

	local ok, published = pcall(chunk)
	if not ok or type(published) ~= "table" then
		return colors
	end

	for key in pairs(defaults) do
		if type(published[key]) == "string" then
			colors[key] = published[key]
		end
	end
	return colors
end

local M = { colors = load() }

local function hex(key)
	local bare = M.colors[key]:gsub("^#", "")
	return bare
end

function M.rgba(key, alpha)
	return "rgba(" .. hex(key) .. alpha .. ")"
end

function M.gradient(from, to, alpha, angle)
	return M.rgba(from, alpha) .. " " .. M.rgba(to, alpha) .. " " .. angle .. "deg"
end

return M
