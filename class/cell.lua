-----------------------------------------------------------------------------------------
-- CELL
-----------------------------------------------------------------------------------------
local Cell = {}
local mt   = { __index = Cell }
-----------------------------------------------------------------------------------------
-- fill color constants 
-----------------------------------------------------------------------------------------
local white = { 1, 1, 1 }
local gray  = { .2, .2, .2 }
-----------------------------------------------------------------------------------------
-- NEW
-----------------------------------------------------------------------------------------
function Cell.new(x, y, row, col, size)
	
	local self = setmetatable({}, mt)

	self.x = x or 0
	self.y = y or 0

	self.row = row or 0
	self.col = col or 0

	self.size = size or 30
	self.rect = display.newRect(self.x, self.y, self.size, self.size)

	-- extra field that will hold the cell state (0: dead, 1: alive)
	self.copy = 0

	-- initially all cells are dead
	self.dead = true

	-- add touch event
	self.rect:addEventListener("touch", self)

	return self
end
-----------------------------------------------------------------------------------------
-- TOUCH
-----------------------------------------------------------------------------------------
function Cell:touch(event)

	if event.phase == "ended" then
		
		if self.dead then
			self:survive()
		else
			self:die()
		end

		self:update()
	end

	return true
end
-----------------------------------------------------------------------------------------
function Cell:die()
	self.dead = true
	self.rect.fill = white
end

function Cell:survive()
	self.dead = false
	self.rect.fill = gray
end

-- update the copy field of cell, this is required for the next run
function Cell:update()
	
	self.copy = (self.dead and 0) or 1
end

function Cell:isAlive()

	return self.copy == 1
end

function Cell:isDead()
	
	return self.copy == 0
end
-----------------------------------------------------------------------------------------
return Cell
-----------------------------------------------------------------------------------------