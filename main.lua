function love.load()
	love.window.setMode(1000, 1000, { resizable = true })
	cellSize = 50 -- TODO: have this set automatically based on size of grid and window?
	lineWidth = 4
	grid = {
		{ 0, 1, 0, 0, 1 },
		{ 1, 1, 2, 0, 1 },
		{ 0, 1, 2, 2, 0 },
		{ 0, 1, 2, 0, 0 },
		{ 2, 1, 2, 2, 0 },
		{ 0, 1, 1, 2, 0 },
		{ 0, 1, 2, 2, 0 },
		{ 1, 1, 2, 2, 0 },
		{ 0, 1, 2, 2, 0 },
	}
end

function love.draw()
	drawGrid(grid, cellSize, lineWidth, 100, 100)
end

function drawGrid(curGrid, curCellSize, lineWidth, x, y)
	local height = #curGrid
	local width = #curGrid[1]
	local numColors = {
		[0] = { 1, 1, 1 },
		[1] = { 76 / 255, 78 / 255, 82 / 255 },
		[2] = { 0, 0, 1 },
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
			love.graphics.setColor(numColors[grid[i + 1][j + 1]])
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
