--- @since 26.0.0

local conf_dir  = os.getenv("YAZI_CONFIG_HOME") or (os.getenv("HOME") .. "/.config/yazi")
local data_file = conf_dir .. "/nicknames.lua"

local function esc(s)
	return s:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", "\\n")
end

local function write(st)
	local lines = { "return {", "\tmode = " .. tostring(st.mode) .. "," }
	local append = function(t, label)
		local n = 0
		for _ in pairs(t) do n = n + 1 end
		if n == 0 then return end
		lines[#lines + 1] = "\t" .. label .. " = {"
		for k, v in pairs(t) do
			lines[#lines + 1] = '\t\t["' .. esc(k) .. '"] = "' .. esc(v) .. '",'
		end
		lines[#lines + 1] = "\t},"
	end
	append(st.names, "names")
	append(st.paths, "paths")
	lines[#lines + 1] = "}"
	return table.concat(lines, "\n")
end

local get_hovered = ya.sync(function()
	local h = cx.active.current.hovered
	if not h then return nil end
	return { url = tostring(h.url), name = h.name }
end)

local get_current = ya.sync(function(st, url, name)
	return st.paths[url] or st.names[name] or ""
end)

local mods = { "off", "on", "on + real name" }
local do_toggle = ya.sync(function(st)
	st.mode = (st.mode + 1) % 3
	ui.render()
	return mods[st.mode + 1], write(st)
end)

local apply_nick = ya.sync(function(st, url, name, value)
	if not value or value == "" then
		st.paths[url] = nil
		st.names[name] = nil
	else
		st.paths[url] = value
		st.names[name] = value
	end
	ui.render()
	return write(st)
end)

local function load(st)
	st.mode, st.names, st.paths = 1, {}, {}
	local ok, chunk = pcall(dofile, data_file)
	if not ok or type(chunk) ~= "table" then return end
	st.mode = chunk.mode or 1
	for k, v in pairs(chunk.names or {}) do st.names[k] = v end
	for k, v in pairs(chunk.paths or {}) do st.paths[k] = v end
end

local function setup(st)
	load(st)

	Linemode:children_add(function(self)
		local ok, res = pcall(function()
			if st.mode == 0 then return nil end
			local nick = st.paths[tostring(self._file.url)] or st.names[self._file.name]
			if not nick then return nil end

			local text = st.mode == 2 and ("⟦" .. nick .. " [" .. tostring(self._file.name) .. "]⟧") or ("⟦" .. nick .. "⟧")
			return ui.Line { ui.Span(" " .. text):fg("yellow") }
		end)
		if not ok then
			ya.err("nicknames render failed: " .. tostring(res))
			return nil
		end
		return res
	end, 400)
end

local function entry(self, job)
	local act = job.args[1] or "toggle"

	if act == "toggle" then
		local label, content = do_toggle()
		fs.write(Url(data_file), content)
		ya.notify { title = "Nicknames", content = "Mode: " .. label, timeout = 3 }
		return
	end

	local picked = get_hovered()
	if not picked then
		ya.notify { title = "Nicknames", content = "Nothing hovered", level = "warn" }
		return
	end

	local current = get_current(picked.url, picked.name)

	if act == "remove" then
		local content = apply_nick(picked.url, picked.name, "")
		fs.write(Url(data_file), content)
		ya.notify { title = "Nicknames", content = "Removed nickname for " .. picked.name, timeout = 3 }
		return
	end

	-- add / edit
	local value, event = ya.input {
		title = "Nickname for " .. picked.name .. ":",
		value = current,
		pos = { "top-center", y = 2, w = 60 },
	}
	if event ~= 1 then return end

	value = value and value:gsub("^%s+", ""):gsub("%s+$", "") or ""

	local content = apply_nick(picked.url, picked.name, value)
	fs.write(Url(data_file), content)
	ya.notify {
		title = "Nicknames",
		content = value == "" and ("Removed nickname for " .. picked.name)
			or ("Set " .. picked.name .. " -> " .. value),
		timeout = 3,
	}
end

return { setup = setup, entry = entry }