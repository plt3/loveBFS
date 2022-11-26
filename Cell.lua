Cell = {}

function Cell:new(num, par)
	local newCell = { number = num, parent = par }
	self.__index = self
	return setmetatable(newCell, self)
end

function Cell:getColorTable()
	local numColors = {
		[0] = { 1, 1, 1 }, -- empty
		[1] = { 76 / 255, 78 / 255, 82 / 255 }, -- wall
		[2] = { 0, 0, 1 }, -- has been checked by algorithm
		[3] = { 1, 0, 0 }, -- source
		[4] = { 0, 1, 0 }, -- destination
		[5] = { 255 / 255, 192 / 255, 203 / 255 }, -- shortest path
	}
	return numColors[self.number]
end

function Cell:print()
	if self.parent ~= nil then
		print("Cell with number " .. self.number .. " and parent number " .. self.parent.number)
	else
		print("Cell with number " .. self.number .. " and no parent")
	end
end

return Cell
