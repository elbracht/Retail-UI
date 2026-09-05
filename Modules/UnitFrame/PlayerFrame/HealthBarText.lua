local _, addonTable = ...
local RetailUI = addonTable.RetailUI
local PlayerFrame = RetailUI:GetModule("PlayerFrame")

local HEALTH_BAR_TEXT_WIDTH = 236
local HEALTH_BAR_TEXT_HEIGHT = 40
local HEALTH_BAR_TEXT_OFFSET_X = 142
local HEALTH_BAR_TEXT_OFFSET_Y = 53

local function GetHealthText(health, maxHealth)
	return health .. " / " .. maxHealth
end

local function GetHealthPercentText(health, maxHealth)
	return math.floor(health / maxHealth * 100 + 0.5) .. "%"
end

function PlayerFrame:CreateHealthBarText(scale)
	local frame = CreateFrame("Frame", nil, self.frame)
	frame:SetSize(HEALTH_BAR_TEXT_WIDTH * scale, HEALTH_BAR_TEXT_HEIGHT * scale)
	frame:SetPoint("TOPLEFT", self.frame, "TOPLEFT", HEALTH_BAR_TEXT_OFFSET_X * scale, -HEALTH_BAR_TEXT_OFFSET_Y * scale)
	frame:SetFrameLevel(self.frame:GetFrameLevel() + 1)

	local textCenter = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	textCenter:SetPoint("CENTER", frame, "CENTER")

	local textLeft = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	textLeft:SetPoint("LEFT", frame, "LEFT")

	local textRight = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	textRight:SetPoint("RIGHT", frame, "RIGHT")

	local function UpdateStatusText()
		local setting = GetCVar("statusTextDisplay")
		local maxHealth = UnitHealthMax("player")
		local health = UnitHealth("player")

		textCenter:SetText("")
		textLeft:SetText("")
		textRight:SetText("")

		if maxHealth == 0 then
			maxHealth = 1
		end

		if setting == "NUMERIC" then
			textCenter:SetText(GetHealthText(health, maxHealth))
		elseif setting == "PERCENT" then
			textCenter:SetText(GetHealthPercentText(health, maxHealth))
		elseif setting == "BOTH" then
			textLeft:SetText(GetHealthText(health, maxHealth))
			textRight:SetText(GetHealthPercentText(health, maxHealth))
		end
	end

	frame:RegisterEvent("CVAR_UPDATE")
	frame:RegisterEvent("UNIT_HEALTH")
	frame:SetScript("OnEvent", function(_, event, unit)
		if event == "UNIT_HEALTH" and unit ~= "player" then return end
		UpdateStatusText()
	end)

	UpdateStatusText()

	return frame
end
