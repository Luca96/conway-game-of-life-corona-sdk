-----------------------------------------------------------------------------------------
-- GRID
-----------------------------------------------------------------------------------------
local Cell = require "class.cell"
-----------------------------------------------------------------------------------------
local Grid = {}
local mt = { __index = Grid }
-----------------------------------------------------------------------------------------
-- screen dimension
-----------------------------------------------------------------------------------------
local screenW, screenH = display.contentWidth, display.contentHeight
local halfW, halfH = screenW / 2, screenH / 2
-----------------------------------------------------------------------------------------
-- NEW
-----------------------------------------------------------------------------------------
function Grid.new(params)
	params = params or {}

	local self = setmetatable({}, mt)

	-- properties
	self.x0 = params.x0 or halfW
	self.y0 = params.y0 or halfH

	self.rows = params.rows or 12
	self.cols = params.cols or 12

	self.cellsize = params.cellsize or 32

	-- keep track of alive cells
	self.cellAlive = 0

	-- timer (required for animation)
	self.timer = nil

	-- display group
	self.group = display.newGroup()
	self.group:translate(self.x0, self.y0)

	-- init
	-- we add 2 extra row to make easier finding live neighbors
	for r = 0, self.rows + 1 do
		self[r] = {} -- here we'll store cells
	end

	return self
end
-----------------------------------------------------------------------------------------
-- DRAW
-----------------------------------------------------------------------------------------
function Grid:draw()
	local size, rows, cols = self.cellsize, self.rows, self.cols
	local x0 = size * cols / -2 + size / 2
	local y0 = size * rows / -2 + size / 2

	-- here we draw the grid centered to (self.x0, self.y0)
	for r = 1, rows do
		for c = 1, cols do
			local x = x0 + size * (c - 1 % cols)
			local y = y0 + size * (r - 1 % rows)

			-- creating a cell
			local cell = Cell.new(x, y, r, c, size)
			self[r][c] = cell
			self.group:insert(cell.rect)
		end
	end
end
-----------------------------------------------------------------------------------------
-- LIVE NEIGHBORS
-----------------------------------------------------------------------------------------
function Grid:neighbors(row, col)
	local r0, r1 = row - 1, row + 1
	local c0, c1 = col - 1, col + 1
		
	-- neighbors indexes (r, c)
	local indexes = { 
		r0,  c0, r0,  col, r0, c1, 
		row, c0, row, c1, 
		r1,  c0, r1, col, r1, c1, 
	}
		
	-- live neighbors
	local list = {}

	-- scanning all 8-neighbors
	for i = 1, 16, 2 do
		local r, c = indexes[i], indexes[i + 1]
		local cell = self[r][c]

		if cell and cell:isAlive() then
			table.insert(list, cell)
		end
	end

	return list
end
-----------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------
-- GoF rules: make cells survive or die
function Grid:rules(row, col)
	local cell = self[row][col]
	local neighbors = self:neighbors(row, col)
	local n = #neighbors

	if cell:isDead() then
		
		if n == 3 then
			cell:survive()
			self.cellAlive = self.cellAlive + 1
		end

	else
		
		if n < 2 then
			cell:die()
			self.cellAlive = self.cellAlive - 1

		elseif n == 2 or n == 3 then
			cell:survive()
			self.cellAlive = self.cellAlive + 1

		elseif n > 3 then
			cell:die()
			self.cellAlive = self.cellAlive - 1
		end
	end
end

function Grid:update()
	local rows = self.rows
	local cols = self.cols

	for r = 1, rows do
		for c = 1, cols do
			
			self:rules(r, c)
		end
	end

	-- finally update all cells
	for r = 1, rows do
		for c = 1, cols do
			
			self[r][c]:update()
		end
	end

	-- check if all cells are dead
	if self.cellAlive <= 0 then
		self.cellAlive = 0

		-- if so stop animation
		if self.timer then
			timer.cancel(self.timer)
			self.timer = nil
		end
	end
end
-----------------------------------------------------------------------------------------
-- ANIMATE
-----------------------------------------------------------------------------------------
function Grid:animate(delay)
	
	if self.timer then
		timer.cancel(self.timer)
		self.timer = nil
	end

	self.frame = 0

	self.timer = timer.performWithDelay(delay, function()
		self:update()
		
		--self.frame = self.frame + 1
		--print("frame: ", self.frame)
	end, 0)
end

function Grid:random()
	for r = 1, self.rows do
		for c = 1, self.cols do
			
			if math.random(100) > 50 then
				self[r][c]:survive()
				self.cellAlive = self.cellAlive + 1
			end
		end
	end
end
-----------------------------------------------------------------------------------------
return Grid
-----------------------------------------------------------------------------------------