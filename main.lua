--- @since 26.5.6

local function marker_style(file)
	local marked = file:is_marked()
	if marked == 1 then
		return th.mgr.marker_marked
	elseif marked == 0 and file:is_selected() then
		return th.mgr.marker_selected
	end
	local yanked = file:is_yanked()
	if yanked == 1 then
		return th.mgr.marker_copied
	elseif yanked == 2 then
		return th.mgr.marker_cut
	end
end

local function render_marker_reversed(area, folder, pad)
	if area.w * area.h == 0 then
		return {}
	end
	local window = folder.window
	if not window or #window == 0 then
		return {}
	end

	local elements = {}
	local function append(last)
		if not last[3] then
			return
		end
		local y = math.min(area.y + last[1], area.y + area.h - 1)
		local rect = ui.Rect {
			x = area.x,
			y = y,
			w = 1,
			h = math.min(1 + last[2] - last[1], area.y + area.h - y),
		}
		elements[#elements + 1] = ui.Bar(ui.Edge.LEFT):area(rect):style(last[3]):symbol(th.mgr.marker_symbol)
	end

	local n = #window
	local last = { -1, -1, nil }
	for idx = n, 1, -1 do
		local f = window[idx]
		local style = marker_style(f)
		local visual_row = pad + (n - idx)

		if last[2] == -1 or visual_row - last[2] > 1 or last[3] ~= style then
			append(last)
			last = { visual_row, visual_row, style }
		else
			last[2] = visual_row
		end
	end
	append(last)
	return elements
end

local function render_reversed(files, area)
	local n = #files
	local pad = math.max(0, area.h - n)

	local left, right = {}, {}
	for i = n, 1, -1 do
		local f = files[i]
		local entity = Entity:new(f)
		left[#left + 1], right[#right + 1] = entity:redraw(), Linemode:new(f):redraw()
		local max = math.max(0, area.w - right[#right]:width())
		left[#left]:truncate { max = max, ellipsis = entity:ellipsis(max) }
	end

	for _ = 1, pad do
		table.insert(left, 1, ui.Line {})
		table.insert(right, 1, ui.Line {})
	end

	return {
		ui.List(left):area(area),
		ui.Text(right):area(area):align(ui.Align.RIGHT),
	}
end

local function cursor_to_last(folder)
	if not folder or not folder.files or #folder.files == 0 then
		return
	end
	folder.cursor = #folder.files - 1
	ya.emit("arrow", { 0 })
end

local inited = {}

local function setup()
	ya.emit("sort", { by = "alphabetical", reverse = false })

	ps.sub("cd", function()
		cursor_to_last(cx.active.current)
		for _, tab in ipairs(cx.tabs) do
			if tab.current then
				inited[tostring(tab.current.cwd)] = true
			end
			if tab.parent then
				inited[tostring(tab.parent.cwd)] = true
			end
		end
	end)

	local old_Current_redraw = Current.redraw
	Current.redraw = function(self, ...)
		local folder = self._folder
		if not folder then
			return old_Current_redraw(self, ...)
		end

		local key = tostring(folder.cwd)
		if not inited[key] then
			inited[key] = true
			cursor_to_last(folder)
		end

		local files = folder.window
		if not files or #files == 0 then
			return old_Current_redraw(self, ...)
		end

		return render_reversed(files, self._area)
	end

	local old_Parent_redraw = Parent.redraw
	Parent.redraw = function(self, ...)
		if not self._folder then
			return {}
		end

		local key = tostring(self._folder.cwd)
		if not inited[key] then
			inited[key] = true
			cursor_to_last(self._folder)
		end

		local files = self._folder.window
		if #files == 0 then
			return old_Parent_redraw(self, ...)
		end

		return render_reversed(files, self._area)
	end

	local folder = require("folder")
	local old_peek = folder.peek
	folder.peek = function(self, job)
		local p_folder = cx.active.preview.folder
		if not p_folder or p_folder.cwd ~= job.file.url then
			return old_peek(self, job)
		end

		local bound = math.max(0, #p_folder.files - job.area.h)
		if job.skip > bound then
			return ya.emit("peek", { bound, only_if = job.file.url, upper_bound = true })
		end

		local files = p_folder.window
		if not files or #files == 0 then
			return old_peek(self, job)
		end

		local n = #files
		local pad = math.max(0, job.area.h - n)

		local left, right = {}, {}
		for i = n, 1, -1 do
			local f = files[i]
			local entity = Entity:new(f)
			left[#left + 1], right[#right + 1] = entity:redraw(), Linemode:new(f):redraw()
			local max = math.max(0, job.area.w - right[#right]:width())
			left[#left]:truncate { max = max, ellipsis = entity:ellipsis(max) }
		end
		for _ = 1, pad do
			table.insert(left, 1, ui.Line {})
			table.insert(right, 1, ui.Line {})
		end

		local marker_area = job.area { x = math.max(0, job.area.x - 1) }
		return ya.preview_widget(job, {
			ui.List(left):area(job.area),
			ui.Text(right):area(job.area):align(ui.Align.RIGHT),
			table.unpack(render_marker_reversed(marker_area, p_folder, pad)),
		})
	end
end

return { setup = setup }
