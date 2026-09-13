require("full-border"):setup()
require("nicknames"):setup()
require("sessions"):setup()
function Linemode:size_and_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	local time_str = (time == 0) and "" or os.date("%b %d %H:%M", time)
	local size = self._file:size()
	local size_str = size and ya.readable_size(size) or "-"

	return ui.Line({
		ui.Span(size_str .. " "),
		ui.Span(time_str),
	})
end

-- FIXED Header: Return a Span, not a raw string
Header:children_add(function()
	return ui.Span("ImSb  "):fg("yellow")
end, 500, Header.LEFT)
