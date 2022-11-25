local utils = require("utils")

function love.load()
	love.window.setMode(1000, 1000, { resizable = true })
	-- TODO: make these all constants in conf.lua
	CellSize = 50 -- TODO: have this set automatically based on size of grid and window?
	LineWidth = 4
	GridLeft = 100
	GridTop = 100
	GridSize = 15
	FramesPerSec = 5

	ElapsedTime = 0
	PrevFrameInt = 0
	Source = nil
	Destination = nil
	Grid = utils.makeGrid(GridSize)
end

function love.mousepressed(x, y, button, istouch, presses)
	-- shift + click should be used to set source and destination, but regular click can
	-- be used to make a wall
	if utils.mouseInGrid(x, y, GridLeft, GridTop, GridSize, CellSize) and Destination == nil then
		local row = math.ceil((y - GridTop) / CellSize)
		local column = math.ceil((x - GridLeft) / CellSize)
		if love.keyboard.isDown("rshift", "lshift") then
			if Source == nil then
				Grid[row][column] = 2
				Source = { row, column }
			else
				Grid[row][column] = 3
				Destination = { row, column }
			end
		else
			Grid[row][column] = 1
		end
	end
end

function love.mousemoved(x, y, dx, dy, istouch)
	-- dragging mouse creates walls
	if utils.mouseInGrid(x, y, GridLeft, GridTop, GridSize, CellSize) and Destination == nil then
		if love.mouse.isDown(1) then
			local row = math.floor((y - GridTop) / CellSize) + 1
			local column = math.floor((x - GridLeft) / CellSize) + 1
			Grid[row][column] = 1
		end
	end
end

function love.update(dt)
	ElapsedTime = ElapsedTime + dt
	if math.floor(FramesPerSec * ElapsedTime) ~= PrevFrameInt then
		PrevFrameInt = math.floor(FramesPerSec * ElapsedTime)
		-- advance frame of algorithm here
		-- should record current cell and have some function that can advance algorithm
		-- one frame based on that cell, etc.
	end
end

function love.draw()
	utils.drawGrid(Grid, CellSize, LineWidth, GridLeft, GridTop)
end
