local M = {}

function M.makeGrid(n)
	-- create nxn grid with all zeros
	local outerTable = {}
	for _ = 1, n do
		local innerTable = {}
		for _ = 1, n do
			table.insert(innerTable, 0)
		end
		table.insert(outerTable, innerTable)
	end
	return outerTable
end

function M.mouseInGrid(x, y, gLeft, gTop, gSize, cSize)
	-- return if mouse (with coords (x,y)) is within grid
	local gRight = gLeft + gSize * cSize
	local gBot = gTop + gSize * cSize
	-- check that mouse is within grid
	return (x > gLeft and x < gRight) and (y > gTop and y < gBot)
end

function M.drawGrid(curGrid, curCellSize, lineWidth, x, y)
	local height = #curGrid
	local width = #curGrid[1]
	local numColors = {
		[0] = { 1, 1, 1 }, -- empty
		[1] = { 76 / 255, 78 / 255, 82 / 255 }, -- wall
		[2] = { 0, 0, 1 }, -- has been check by algorithm
		[3] = { 1, 0, 0 }, -- destination
	}

	love.graphics.setLineWidth(lineWidth)
	love.graphics.setColor(0, 0, 0)

	-- draw vertical lines
	for i = 0, width do
		local line = { x + i * curCellSize, y, x + i * curCellSize, y + height * curCellSize }
		love.graphics.line(line)
	end

	-- draw horizontal lines
	for i = 0, height do
		local line = { x, y + i * curCellSize, x + width * curCellSize, y + i * curCellSize }
		love.graphics.line(line)
	end

	for i = 0, height - 1 do
		for j = 0, width - 1 do
			love.graphics.setColor(numColors[Grid[i + 1][j + 1]])
			love.graphics.rectangle(
				"fill",
				x + lineWidth / 2 + j * curCellSize,
				y + lineWidth / 2 + i * curCellSize,
				curCellSize - lineWidth,
				curCellSize - lineWidth
			)
		end
	end
end

return M