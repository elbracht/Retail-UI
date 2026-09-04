local _, addonTable = ...
local RetailUI = addonTable.RetailUI
local PlayerFrame = RetailUI:GetModule("PlayerFrame")

local HEALTH_BAR_WIDTH = 251
local HEALTH_BAR_HEIGHT = 40
local HEALTH_BAR_OFFSET_X = 133
local HEALTH_BAR_OFFSET_Y = 53

local HEALTH_COLOR_GREEN_1 = CreateColor(49/255, 149/255, 8/255)
local HEALTH_COLOR_GREEN_2 = CreateColor(131/255, 226/255, 49/255)
local HEALTH_COLOR_YELLOW_1 = CreateColor(191/255, 164/255, 0/255)
local HEALTH_COLOR_YELLOW_2 = CreateColor(255/255, 254/255, 76/255)
local HEALTH_COLOR_RED_1 = CreateColor(157/255, 0/255, 0/255)
local HEALTH_COLOR_RED_2 = CreateColor(255/255, 91/255, 56/255)

local function GetHealthGradient(healthPercent)
	local color1, color2
	if healthPercent > 0.5 then
		color1 = HEALTH_COLOR_GREEN_1
		color2 = HEALTH_COLOR_GREEN_2
	elseif healthPercent > 0.2 then
		color1 = HEALTH_COLOR_YELLOW_1
		color2 = HEALTH_COLOR_YELLOW_2
	else
		color1 = HEALTH_COLOR_RED_1
		color2 = HEALTH_COLOR_RED_2
	end
	return color1, color2
end

function PlayerFrame:CreateHealthBar(scale)
	local healthBar = CreateFrame("Frame", nil, self.frame)
	healthBar:SetSize(HEALTH_BAR_WIDTH * scale, HEALTH_BAR_HEIGHT * scale)
	healthBar:SetPoint("TOPLEFT", self.frame, "TOPLEFT", HEALTH_BAR_OFFSET_X * scale, -HEALTH_BAR_OFFSET_Y * scale)
	healthBar:SetFrameLevel(self.frame:GetFrameLevel() + 1)

	local fill = healthBar:CreateTexture(nil, "ARTWORK")
	fill:SetAllPoints()
	fill:SetTexture("Interface/Buttons/WHITE8x8")

	local shadow = healthBar:CreateTexture(nil, "OVERLAY")
	shadow:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UnitFrame\\PlayerFrame\\PlayerFrame-HealthBar-Shadow.blp")
	shadow:SetAllPoints()

	local mask = healthBar:CreateMaskTexture(nil, "ARTWORK")
	mask:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UnitFrame\\PlayerFrame\\PlayerFrame-HealthBar-Mask.blp")
	mask:SetAllPoints()
	fill:AddMaskTexture(mask)
	shadow:AddMaskTexture(mask)

	local function UpdateHealth()
		local maxHealth = UnitHealthMax("player")
		if maxHealth == 0 then maxHealth = 1 end

		local healthPercent = UnitHealth("player") / maxHealth
		local color1, color2 = GetHealthGradient(healthPercent)

		fill:SetGradient("HORIZONTAL", color1, color2)
		fill:SetPoint("TOPRIGHT", healthBar, "TOPRIGHT", -(HEALTH_BAR_WIDTH * scale * (1 - healthPercent)), 0)
	end

	healthBar:RegisterEvent("UNIT_HEALTH")
	healthBar:SetScript("OnEvent", function()
		UpdateHealth()
	end)

	UpdateHealth()

	return healthBar
end
