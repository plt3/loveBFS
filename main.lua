local utils = require("utils")
local algorithms = require("algorithms")
require("constants")

function love.load()
	love.window.setMode(1000, 1000, { resizable = true })
	love.window.setTitle("BFS/DFS Visualization")

	RunBFS = true
	ElapsedTime = 0
	PrevFrameInt = 0
	QueueStack = {}
	CurBFSCoords = {}
	Destination = nil
	AlgoResult = nil
	AlgRunning = false
	Grid = utils.makeGrid(GRID_SIZE)

	Font = love.graphics.newFont(30)
	love.graphics.setFont(Font)
end

function love.mousepressed(x, y, button, istouch, presses)
	-- shift + click should be used to set source and destination, but regular click can
	-- be used to make a wall
	if utils.mouseInGrid(x, y, GRID_LEFT, GRID_TOP, GRID_SIZE, CELL_SIZE) and not AlgRunning then
		local row = math.ceil((y - GRID_TOP) / CELL_SIZE)
		local column = math.ceil((x - GRID_LEFT) / CELL_SIZE)
		local curCell = Grid[row][column]
		if presses == 2 then -- double click to set source/destination
			if #QueueStack == 0 then
				curCell.number = 3
				table.insert(QueueStack, { row, column }) -- insert source into queue/stack
			else
				curCell.number = 4
				Destination = { row, column }
			end
		else
			if love.keyboard.isDown("rshift", "lshift") then -- shift + click to erase cell
				if curCell.number == 3 then -- if erasing source
					table.remove(QueueStack)
				end
				curCell.number = 0
			else
				curCell.number = 1
			end
		end
	end
end

function love.mousemoved(x, y, dx, dy, istouch)
	-- dragging mouse creates walls, holding shift erases them
	if utils.mouseInGrid(x, y, GRID_LEFT, GRID_TOP, GRID_SIZE, CELL_SIZE) and not AlgRunning then
		if love.mouse.isDown(1) then
			local row = math.floor((y - GRID_TOP) / CELL_SIZE) + 1
			local column = math.floor((x - GRID_LEFT) / CELL_SIZE) + 1
			if love.keyboard.isDown("rshift", "lshift") then
				if Grid[row][column].number == 3 then -- if erasing source
					table.remove(QueueStack)
				end
				Grid[row][column].number = 0
			else
				Grid[row][column].number = 1
			end
		end
	end
end

function love.keypressed(key, isrepeat)
	if Destination ~= nil and key == "return" then -- start algorithm
		AlgoResult = nil
		AlgRunning = true
	elseif not AlgRunning and key == "r" then -- clear algorithm path
		utils.clearPath(Grid, QueueStack)
		AlgoResult = nil
	elseif not AlgRunning and key == "c" then -- completely clear grid
		Grid = utils.makeGrid(GRID_SIZE)
		AlgoResult = nil
		QueueStack = {}
	elseif not AlgRunning and key == "a" then -- toggle between BFS and DFS
		RunBFS = not RunBFS
	end
end

function love.update(dt)
	ElapsedTime = ElapsedTime + dt
	if math.floor(FRAMES_PER_SEC * ElapsedTime) ~= PrevFrameInt then
		PrevFrameInt = math.floor(FRAMES_PER_SEC * ElapsedTime)
		if AlgRunning and AlgoResult == nil then
			-- only get next frame if destination has been set and algorithm is not done
			if RunBFS then
				AlgoResult = algorithms.advanceBFS(Grid, QueueStack, CurBFSCoords)
			else
				AlgoResult = algorithms.advanceDFS(Grid, QueueStack)
			end
		elseif AlgoResult ~= nil then
			AlgRunning = false
			-- algorithm has terminated, so clear any variables used in it
			QueueStack = {}
			CurBFSCoords = {}
		end
	end
end

function love.draw()
	utils.drawGrid(Grid, CELL_SIZE, LINE_WIDTH, GRID_LEFT, GRID_TOP)
	love.graphics.setColor(1, 1, 1)
	if AlgoResult ~= nil then
		if AlgoResult == -1 then
			love.graphics.print("No path found.")
		else
			love.graphics.print("Path of length " .. AlgoResult .. " found.")
		end
	end
	if RunBFS then
		love.graphics.print("[BFS]", love.graphics.getWidth() - 150, 0)
	else
		love.graphics.print("[DFS]", love.graphics.getWidth() - 150, 0)
	end
end
