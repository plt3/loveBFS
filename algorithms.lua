local utils = require("utils")

local M = {}

function M.advanceBFS(grid, queue, curCoords)
	if #queue == 0 then
		-- algorithm is done, means it didn't find destination
		return -1
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
		return utils.colorPath(curCell)
	end
	if grid[upOne][curCoords[2]].number == 0 then -- check above
		grid[upOne][curCoords[2]].number = 2
		grid[upOne][curCoords[2]].parent = curCell
		table.insert(queue, { upOne, curCoords[2] })
		madeChange = true
	end

	if grid[curCoords[1]][rightOne].number == 4 then
		return utils.colorPath(curCell)
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
		return utils.colorPath(curCell)
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
		return utils.colorPath(curCell)
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

function M.advanceDFS(grid, stack)
	if #stack == 0 then
		-- algorithm is done, means it didn't find destination
		return -1
	end

	local curCoords = table.remove(stack)
	local curCell = grid[curCoords[1]][curCoords[2]]
	if curCell.number ~= 3 then -- don't change color of source cell
		curCell.number = 2
	end

	local upOne = math.max(1, curCoords[1] - 1)
	local rightOne = math.min(#grid[1], curCoords[2] + 1)
	local downOne = math.min(#grid, curCoords[1] + 1)
	local leftOne = math.max(1, curCoords[2] - 1)

	if grid[upOne][curCoords[2]].number == 4 then
		return utils.colorPath(curCell)
	end
	if grid[upOne][curCoords[2]].number == 0 then -- check above
		grid[upOne][curCoords[2]].parent = curCell
		table.insert(stack, { upOne, curCoords[2] })
	end

	if grid[curCoords[1]][rightOne].number == 4 then
		return utils.colorPath(curCell)
	end
	if grid[curCoords[1]][rightOne].number == 0 then -- check right
		grid[curCoords[1]][rightOne].parent = curCell
		table.insert(stack, { curCoords[1], rightOne })
	end

	if grid[downOne][curCoords[2]].number == 4 then
		return utils.colorPath(curCell)
	end
	if grid[downOne][curCoords[2]].number == 0 then -- check down
		grid[downOne][curCoords[2]].parent = curCell
		table.insert(stack, { downOne, curCoords[2] })
	end

	if grid[curCoords[1]][leftOne].number == 4 then
		return utils.colorPath(curCell)
	end
	if grid[curCoords[1]][leftOne].number == 0 then -- check left
		grid[curCoords[1]][leftOne].parent = curCell
		table.insert(stack, { curCoords[1], leftOne })
	end
end

return M
