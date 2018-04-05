-----------------------------------------------------------------------------------------
-- Conway's Game of Life
--
-- main.lua
--
-- author: Luca Anzalone (05/04/2018)
-----------------------------------------------------------------------------------------
local Grid = require "class.grid"
-----------------------------------------------------------------------------------------
local screenW = display.contentWidth
local screenH = display.contentHeight
local fps30 = 1000 / 30
local fps60 = 1000 / 60
-----------------------------------------------------------------------------------------
local function find_row_col(cellsize)
	local rows = math.round(screenH / cellsize)
	local cols = math.round(screenW / cellsize)
	
	return rows, cols
end

local function main()
	local cellsize = 8
	local rows, cols = find_row_col(cellsize)

	-- create grid
	local grid = Grid.new { rows = rows, cols = cols, cellsize = cellsize }

	-- render grid
	grid:draw()
	grid:random()

	-- press s key to start
	Runtime:addEventListener("key", function (event)
		local key = event.keyName

		if event.phase == "down" and key == "s" then
			
			grid:animate(fps30)
		end
	end)
end
-----------------------------------------------------------------------------------------
main()
-----------------------------------------------------------------------------------------