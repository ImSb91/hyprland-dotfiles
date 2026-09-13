--- @since 26.0.0

local get_hovered = ya.sync(function()
	local h = cx.active.current.hovered
	if not h then return nil end
	return { dir = h.cha.is_dir }
end)

return {
	entry = function()
		local h = get_hovered()
		if not h then return end
		-- directories are entered; anything else goes through the open rules,
		-- which decide whether to extract (zip/rar/...), run (AppImage), or open
		ya.emit(h.dir and "enter" or "open", { hovered = true })
	end,
}