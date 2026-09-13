--- @since 26.0.0

local received = ya.sync(function()
	local cwd = cx.active.current.cwd
	local files = {}

	local function push(f)
		local rel = f.url:strip_prefix(cwd)
		table.insert(files, rel and tostring(rel) or tostring(f.url))
	end

	if #cx.active.selected > 0 then
		for _, f in pairs(cx.active.selected) do
			push(f)
		end
	elseif cx.active.current.hovered then
		push(cx.active.current.hovered)
	else
		return nil
	end
	return { cwd = tostring(cwd), files = files }
end)

return {
	entry = function()
		local picked = received()
		if not picked or #picked.files == 0 then
			ya.notify { title = "Compress", content = "Select files first", level = "warn" }
			return
		end

		local function no_ext(name)
			return name:match("^(.*)%.[^%.]+$") or name
		end

		local default
		if #picked.files == 1 then
			local last = picked.files[1]:match("/([^/]+)$") or picked.files[1]
			default = no_ext(last)
		else
			default = picked.cwd:match("([^/]+)/?$")
		end

		local value, event = ya.input {
			pos = { "top-center", y = 2, w = 60 },
			title = "Zip name:",
			value = default or "",
		}
		if event ~= 1 or not value or value == "" then
			return
		end

		local name = value
		if not name:lower():find("%.zip$") then
			name = name .. ".zip"
		end

		local cmd = Command("zip"):arg("-r"):arg(name):cwd(picked.cwd)
		for _, f in ipairs(picked.files) do
			cmd:arg(f)
		end

		local out, err = cmd:output()
		if out and out.status.success then
			ya.notify { title = "Compress", content = "Created " .. name, timeout = 5, level = "info" }
			ya.emit("reveal", { Url(picked.cwd .. "/" .. name) })
		elseif out then
			ya.notify { title = "Compress", content = "zip failed: " .. (out.stderr or ""), timeout = 8, level = "error" }
		else
			ya.notify { title = "Compress", content = "zip can't run: " .. tostring(err), timeout = 8, level = "error" }
		end
	end,
}