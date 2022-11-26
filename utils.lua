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

function M.mouseInGrid(x, y, gLeft, gTop, gSize, cSize)
	-- return if mouse (with coords (x,y)) is within grid
	local gRight = gLeft + gSize * cSize
	local gBot = gTop + gSize * cSize
	return (x > gLeft and x < gRight) and (y > gTop and y < gBot)
end

function M.colorPath(startCell)
	while startCell.parent ~= nil do
		startCell.number = 5
		startCell = startCell.parent
	end
end

function M.advanceBFS(grid, queue, curCoords)
	if #queue == 0 then
		-- algorithm is done, means it didn't find destination
		return "failure"
	end
	if #curCoords == 0 then
		-- dequeue and assign result to curCoords
		local temp = table.remove(queue, 1)
		table.insert(curCoords, temp[1])
		table.insert(curCoords, temp[2])
	end

	local curCell = grid[curCoords[1]][curCoords[2]]

	local madeChange = false
	local remainingAdj = false
	local upOne = math.max(1, curCoords[1] - 1)
	local rightOne = math.min(#grid[1], curCoords[2] + 1)
	local downOne = math.min(#grid, curCoords[1] + 1)
	local leftOne = math.max(1, curCoords[2] - 1)

	if grid[upOne][curCoords[2]].number == 4 then
		M.colorPath(curCell)
		return "done"
	end
	if grid[upOne][curCoords[2]].number == 0 then -- check above
		grid[upOne][curCoords[2]].number = 2
		grid[upOne][curCoords[2]].parent = curCell
		table.insert(queue, { upOne, curCoords[2] })
		madeChange = true
	end

	if grid[curCoords[1]][rightOne].number == 4 then
		M.colorPath(curCell)
		return "done"
	end
	if grid[curCoords[1]][rightOne].number == 0 then -- check right
		if not madeChange then
			grid[curCoords[1]][rightOne].number = 2
			grid[curCoords[1]][rightOne].parent = curCell
			table.insert(queue, { curCoords[1], rightOne })
			madeChange = true
		else
			remainingAdj = true
		end
	end

	if grid[downOne][curCoords[2]].number == 4 then
		M.colorPath(curCell)
		return "done"
	end
	if grid[downOne][curCoords[2]].number == 0 then -- check down
		if not madeChange then
			grid[downOne][curCoords[2]].number = 2
			grid[downOne][curCoords[2]].parent = curCell
			table.insert(queue, { downOne, curCoords[2] })
			madeChange = true
		else
			remainingAdj = true
		end
	end

	if grid[curCoords[1]][leftOne].number == 4 then
		M.colorPath(curCell)
		return "done"
	end
	if grid[curCoords[1]][leftOne].number == 0 then -- check left
		if not madeChange then
			grid[curCoords[1]][leftOne].number = 2
			grid[curCoords[1]][leftOne].parent = curCell
			table.insert(queue, { curCoords[1], leftOne })
			madeChange = true
		else
			remainingAdj = true
		end
	end

	if not remainingAdj then
		-- if we've gone through all adjacent cells, then clear curCoords (so the next
		-- one can be dequeued)
		table.remove(curCoords)
		table.remove(curCoords)
	end
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
