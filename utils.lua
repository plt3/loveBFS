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
	return (x > gLeft and x < gRight) and (y > gTop and y < gBot)
end

function M.advanceBFS(grid, queue, curCell)
	if #queue == 0 then
		-- algorithm is done, probably means that it didn't find destination?
		return "failure"
	end
	if #curCell == 0 then
		-- dequeue and assign result to curCell
		local temp = table.remove(queue, 1)
		table.insert(curCell, temp[1])
		table.insert(curCell, temp[2])
	end

	local madeChange = false
	local remainingAdj = false
	local upOne = math.max(1, curCell[1] - 1)
	local rightOne = math.min(#grid[1], curCell[2] + 1)
	local downOne = math.min(#grid, curCell[1] + 1)
	local leftOne = math.max(1, curCell[2] - 1)

	if grid[upOne][curCell[2]] == 3 then
		return "done"
	end
	if grid[upOne][curCell[2]] == 0 then -- check above
		grid[upOne][curCell[2]] = 2
		table.insert(queue, { upOne, curCell[2] })
		madeChange = true
	end

	if grid[curCell[1]][rightOne] == 3 then
		return "done"
	end
	if grid[curCell[1]][rightOne] == 0 then -- check right
		if not madeChange then
			grid[curCell[1]][rightOne] = 2
			table.insert(queue, { curCell[1], rightOne })
			madeChange = true
		else
			remainingAdj = true
		end
	end

	if grid[downOne][curCell[2]] == 3 then
		return "done"
	end
	if grid[downOne][curCell[2]] == 0 then -- check down
		if not madeChange then
			grid[downOne][curCell[2]] = 2
			table.insert(queue, { downOne, curCell[2] })
			madeChange = true
		else
			remainingAdj = true
		end
	end

	if grid[curCell[1]][leftOne] == 3 then
		return "done"
	end
	if grid[curCell[1]][leftOne] == 0 then -- check left
		if not madeChange then
			grid[curCell[1]][leftOne] = 2
			table.insert(queue, { curCell[1], leftOne })
			madeChange = true
		else
			remainingAdj = true
		end
	end

	if not remainingAdj then
		-- if we've gone through all adjacent cells, then clear curCell (so the next
		-- one can be dequeued)
		table.remove(curCell)
		table.remove(curCell)
	end
end

function M.drawGrid(curGrid, curCellSize, lineWidth, x, y)
	local height = #curGrid
	local width = #curGrid[1]
	local numColors = {
		[0] = { 1, 1, 1 }, -- empty
		[1] = { 76 / 255, 78 / 255, 82 / 255 }, -- wall
		[2] = { 0, 0, 1 }, -- has been checked by algorithm
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
