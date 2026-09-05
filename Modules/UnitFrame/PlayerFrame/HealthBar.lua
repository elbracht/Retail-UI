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
	local frame = CreateFrame("Frame", nil, self.frame)
	frame:SetSize(HEALTH_BAR_WIDTH * scale, HEALTH_BAR_HEIGHT * scale)
	frame:SetPoint("TOPLEFT", self.frame, "TOPLEFT", HEALTH_BAR_OFFSET_X * scale, -HEALTH_BAR_OFFSET_Y * scale)
	frame:SetFrameLevel(self.frame:GetFrameLevel() - 1)

	local background = frame:CreateTexture(nil, "BACKGROUND")
	background:SetAllPoints()
	background:SetColorTexture(27/255, 26/255, 24/255, 0.6)

	local fill = frame:CreateTexture(nil, "ARTWORK")
	fill:SetAllPoints()
	fill:SetTexture("Interface/Buttons/WHITE8x8")

	local mask = frame:CreateMaskTexture(nil, "ARTWORK")
	mask:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UnitFrame\\PlayerFrame\\PlayerFrame-HealthBar-Mask.blp")
	mask:SetAllPoints()
	fill:AddMaskTexture(mask)
	background:AddMaskTexture(mask)

	local function UpdateStatusText()
		local setting = GetCVar("statusTextDisplay")
		local maxHealth = UnitHealthMax("player")
		local health = UnitHealth("player")

		if setting == "NUMERIC" then
			statusText:SetText(health .. " / " .. maxHealth)
		elseif setting == "PERCENT" then
			statusText:SetText(math.floor(health / maxHealth * 100 + 0.5) .. "%")
		elseif setting == "BOTH" then
			statusText:SetText(health .. " / " .. maxHealth .. " (" .. math.floor(health / maxHealth * 100 + 0.5) .. "%)")
		else
			statusText:SetText("")
		end
	end

	local function UpdateHealth()
		local maxHealth = UnitHealthMax("player")
		if maxHealth == 0 then maxHealth = 1 end

		local healthPercent = UnitHealth("player") / maxHealth
		local color1, color2 = GetHealthGradient(healthPercent)

		fill:SetGradient("HORIZONTAL", color1, color2)
		fill:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -(HEALTH_BAR_WIDTH * scale * (1 - healthPercent)), 0)
	end

	frame:RegisterEvent("UNIT_HEALTH")
	frame:SetScript("OnEvent", function()
		UpdateHealth()
	end)

	UpdateHealth()

	return frame
end
