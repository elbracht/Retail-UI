local _, addonTable = ...
local RetailUI = addonTable.RetailUI
local PlayerFrame = RetailUI:GetModule("PlayerFrame")
local Textures = addonTable.Textures
local Colors = addonTable.Colors

local POWER_BAR_WIDTH = 248
local POWER_BAR_HEIGHT = 23
local POWER_BAR_OFFSET_X = 136
local POWER_BAR_OFFSET_Y = 96

function PlayerFrame:CreatePowerBar(scale)
	local frame = CreateFrame("Frame", nil, self.frame)
	frame:SetSize(POWER_BAR_WIDTH * scale, POWER_BAR_HEIGHT * scale)
	frame:SetPoint("TOPLEFT", self.frame, "TOPLEFT", POWER_BAR_OFFSET_X * scale, -POWER_BAR_OFFSET_Y * scale)
	frame:SetFrameLevel(self.frame:GetFrameLevel() - 1)

	local backgroundColor = Colors.GetBackgroundColor()
	local background = frame:CreateTexture(nil, "BACKGROUND")
	background:SetAllPoints()
	background:SetColorTexture(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a)

	local fill = frame:CreateTexture(nil, "ARTWORK")
	fill:SetAllPoints()
	fill:SetTexture("Interface\\Buttons\\WHITE8x8")

	local mask = frame:CreateMaskTexture(nil, "ARTWORK")
	mask:SetTexture(Textures.GetTexturePath("UnitFrame\\PlayerFrame\\PlayerFrame-PowerBar-Mask.blp"))
	mask:SetAllPoints()
	fill:AddMaskTexture(mask)
	background:AddMaskTexture(mask)

	local function UpdatePower()
		local maxPower = UnitPowerMax("player")
		if maxPower == 0 then maxPower = 1 end

		local percent = UnitPower("player") / maxPower
		local type = UnitPowerType("player")
		local color = Colors.GetPowerBarColor(type)

		fill:SetGradient("HORIZONTAL", Colors.Darken(color, 0.4), Colors.Lighten(color, 0.2))
		fill:SetPoint("RIGHT", frame, "RIGHT", -(POWER_BAR_WIDTH * scale * (1 - percent)), 0)
	end

	frame:RegisterEvent("UNIT_POWER_UPDATE")
	frame:SetScript("OnEvent", function(_, _, unit)
		if unit ~= "player" then return end
		UpdatePower()
	end)

	UpdatePower()

	return frame
end
