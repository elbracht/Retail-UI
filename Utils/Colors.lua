local _, addonTable = ...

local Colors = {}

-- Colors
local BaseColorTable = {
	BlackTransparent = { r = 27/255, g = 26/255, b = 24/255, a = 0.6 },
	Green = { r = 103/255, g = 215/255, b = 34/255, a = 1 },
	Yellow = { r = 243/255, g = 227/255, b = 13/255, a = 1 },
	Red = { r = 217/255, g = 43/255, b = 0/255, a = 1 },
	Blue = { r = 18/255, g = 114/255, b = 234/255, a = 1 },
	Orange = { r = 234/255, g = 115/255, b = 18/255, a = 1 },
}

local ColorTable = {
	Background = BaseColorTable.BlackTransparent,

	HealthHigh = BaseColorTable.Green,
	HealthMid = BaseColorTable.Yellow,
	HealthLow = BaseColorTable.Red,

	PowerMana = BaseColorTable.Blue,
	PowerRage = BaseColorTable.Red,
	PowerFocus = BaseColorTable.Yellow,
	PowerEnergy = BaseColorTable.Orange,
}

local PowerColorByType = {
	[0] = ColorTable.PowerMana,
	[1] = ColorTable.PowerRage,
	[2] = ColorTable.PowerFocus,
	[3] = ColorTable.PowerEnergy,
}

function Colors.GetBackgroundColor()
	return ColorTable.Background
end

function Colors.GetHealthBarColor(healthPercent)
	if healthPercent > 0.5 then
		return ColorTable.HealthHigh
	elseif healthPercent > 0.2 then
		return ColorTable.HealthMid
	end
	return ColorTable.HealthLow
end

function Colors.GetPowerBarColor(powerType)
	return PowerColorByType[powerType] or ColorTable.PowerMana
end

-- Helpers
function Colors.Lighten(color, amount)
	local r = color.r + (1 - color.r) * amount
	local g = color.g + (1 - color.g) * amount
	local b = color.b + (1 - color.b) * amount
	return CreateColor(r, g, b)
end

function Colors.Darken(color, amount)
	local r = color.r * (1 - amount)
	local g = color.g * (1 - amount)
	local b = color.b * (1 - amount)
	return CreateColor(r, g, b)
end

addonTable.Colors = Colors
