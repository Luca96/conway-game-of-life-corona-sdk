local width  = display.pixelWidth
local height = display.pixelHeight

local ratio = height / width
local base  = 600

application =
{
	content =
	{
		width  = base,
		height = base * ratio, 
		scale  = "letterBox",
		audioPlayFrequency = 22050,
		fps = 60,
	},
}
