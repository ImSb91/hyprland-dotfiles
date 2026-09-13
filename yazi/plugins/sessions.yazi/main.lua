--- @since 26.0.0

local conf_dir     = os.getenv("YAZI_CONFIG_HOME") or (os.getenv("HOME") .. "/.config/yazi")
local session_file = conf_dir .. "/session.lua"

local function esc(s)
	return s:gsub("\\", "\\\\"):gsub('"', '\\"')
end

local do_collect = ya.sync(function()
	local cwds, tabs = {}, cx.tabs
	for i = 1, #tabs do
		local cwd = tabs[i].current.cwd
		if cwd then cwds[#cwds + 1] = tostring(cwd) end
	end
	return { cwds = cwds, active = cx.tabs.idx }
end)

local function read_session()
	local ok, chunk = pcall(dofile, session_file)
	if not ok or type(chunk) ~= "table" then return nil end
	return chunk
end

local function write_session(snap)
	local body = "return {\n\tactive = " .. tostring(snap.active) .. ",\n\tcwd = {"
	for _, wd in ipairs(snap.cwds) do
		body = body .. "\n\t\t\"" .. esc(wd) .. "\","
	end
	body = body .. "\n\t},\n}\n"
	return body
end

local function write_session_file(snap)
	local f = io.open(session_file, "w")
	if f ~= nil then
		f:write(write_session(snap))
		f:close()
	end
end

local do_save_and_quit = ya.sync(function()
	write_session_file(do_collect())
	ya.emit("quit", {})
end)

local function setup(st)
	st.session = read_session()
	st.restored = false

	ps.sub("cd", function()
		if st.restored or not st.session then return end
		st.restored = true

		local initial = tostring(cx.active.current.cwd)
		for _, wd in ipairs(st.session.cwd or {}) do
			if wd and wd ~= initial then
				ya.emit("tab_create", { Url(wd) })
			end
		end

		local active = st.session.active or 1
		if active ~= cx.tabs.idx then
			ya.emit("tab_switch", { active - 1 })
		end
	end)
end

local function entry(self, job)
	if job.args[1] == "save-and-quit" then
		do_save_and_quit()
	end
end

return { setup = setup, entry = entry }