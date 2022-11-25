local utils = require("utils")

function love.load()
	love.window.setMode(1000, 1000, { resizable = true })
	-- TODO: make these all constants in conf.lua
	CellSize = 50 -- TODO: have this set automatically based on size of grid and window?
	LineWidth = 4
	GridLeft = 100
	GridTop = 100
	GridSize = 15

	SourceSet = false
	DestSet = false
	Grid = utils.makeGrid(GridSize)
end

function love.mousepressed(x, y, button, istouch, presses)
	-- shift + click should be used to set source and destination, but regular click can
	-- be used to make a wall
	if utils.mouseInGrid(x, y, GridLeft, GridTop, GridSize, CellSize) then
		local row = math.floor((y - GridTop) / CellSize) + 1
		local column = math.floor((x - GridLeft) / CellSize) + 1
		if love.keyboard.isDown("rshift", "lshift") then
			if not SourceSet then
				Grid[row][column] = 2
				SourceSet = true
			else
				Grid[row][column] = 3
				DestSet = true
			end
		else
			Grid[row][column] = 1
		end
	end
end

function love.mousemoved(x, y, dx, dy, istouch)
	-- dragging mouse creates walls
	if utils.mouseInGrid(x, y, GridLeft, GridTop, GridSize, CellSize) then
		if love.mouse.isDown(1) then
			local row = math.floor((y - GridTop) / CellSize) + 1
			local column = math.floor((x - GridLeft) / CellSize) + 1
			Grid[row][column] = 1
		end
	end
end

function love.draw()
	utils.drawGrid(Grid, CellSize, LineWidth, GridLeft, GridTop)
end
