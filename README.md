# Conway's Game of Life
Conway's Game of Life implemented in Lua for Corona Sdk

## Usage:
* Press the __'s' key__ to start animating the cells

* _Touch on cells_ to make them _dead_ or _alive_:
  - a __dead__ (white) cell became __alive__ (black) when touched
  - an __alive__ (black) cell became __dead__ (white) when touched
 
* You can make some __customization__ by editing ```main.lua```:
```lua
-- 1. change the number of rows and cols by changing the cell size:
local cellsize = whatever_value_you_want

-- or: change rows, cols and cell size arbitrarily by editing:
local grid = Grid.new { rows = rows, cols = cols, cellsize = cellsize }

-- 2. comment this line to freely init cells by tapping on them
grid:random()

-- 3. change (or add) the start key
if event.phase == "down" and key == your_key then
  -- stuff
end

-- 4. change the frame rate (time is in milliseconds)
grid:animate(your_delay)
```

## Example:
![GoL gif](https://github.com/Luca96/conway-game-of-life-corona-sdk/blob/master/gof_anim.gif)
