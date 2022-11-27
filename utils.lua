local Cell = require("Cell")

local M = {}

function M.makeGrid(n)
	-- create nxn grid with all zeros
	local outerTable = {}
	for _ = 1, n do
		local innerTable = {}
		for _ = 1, n do
			table.insert(innerTable, Cell:new(0, nil))
		end
		table.insert(outerTable, innerTable)
	end
	return outerTable
end

function M.clearPath(grid, queueStack)
	for i = 1, #grid do
		for j = 1, #grid[i] do
			if grid[i][j].number == 2 or grid[i][j].number == 5 then
				grid[i][j].number = 0
			elseif grid[i][j].number == 3 then
				table.insert(queueStack, { i, j })
			end
		end
	end
end

function M.mouseInGrid(x, y, gLeft, gTop, gSize, cSize)
	-- return if mouse (with coords (x,y)) is within grid
	local gRight = gLeft + gSize * cSize
	local gBot = gTop + gSize * cSize
	return (x > gLeft and x < gRight) and (y > gTop and y < gBot)
end

function M.colorPath(startCell)
	local total = 1
	while startCell.parent ~= nil do
		startCell.number = 5
		startCell = startCell.parent
		total = total + 1
	end
	return total
end

function M.drawGrid(curGrid, curCellSize, lineWidth, x, y)
	local height = #curGrid
	local width = #curGrid[1]

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
			love.graphics.setColor(Grid[i + 1][j + 1]:getColorTable())
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
