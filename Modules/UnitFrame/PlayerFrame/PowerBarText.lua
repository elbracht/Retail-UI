local _, addonTable = ...
local RetailUI = addonTable.RetailUI
local PlayerFrame = RetailUI:GetModule("PlayerFrame")

local POWER_BAR_TEXT_WIDTH = 236
local POWER_BAR_TEXT_HEIGHT = 23
local POWER_BAR_TEXT_OFFSET_X = 142
local POWER_BAR_TEXT_OFFSET_Y = 96

local function GetPowerText(power, maxPower)
	return power .. " / " .. maxPower
end

local function GetPowerPercentText(power, maxPower)
	return math.floor(power / maxPower * 100 + 0.5) .. "%"
end

function PlayerFrame:CreatePowerBarText(scale)
	local frame = CreateFrame("Frame", nil, self.frame)
	frame:SetSize(POWER_BAR_TEXT_WIDTH * scale, POWER_BAR_TEXT_HEIGHT * scale)
	frame:SetPoint("TOPLEFT", self.frame, "TOPLEFT", POWER_BAR_TEXT_OFFSET_X * scale, -POWER_BAR_TEXT_OFFSET_Y * scale)
	frame:SetFrameLevel(self.frame:GetFrameLevel() + 1)

	local textCenter = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	textCenter:SetPoint("CENTER", frame, "CENTER")

	local textLeft = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	textLeft:SetPoint("LEFT", frame, "LEFT")

	local textRight = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	textRight:SetPoint("RIGHT", frame, "RIGHT")

	local function UpdateStatusText()
		local setting = GetCVar("statusTextDisplay")
		local maxPower = UnitPowerMax("player")
		local power = UnitPower("player")

		textCenter:SetText("")
		textLeft:SetText("")
		textRight:SetText("")

		if maxPower == 0 then
			maxPower = 1
		end

		if setting == "NUMERIC" then
			textCenter:SetText(GetPowerText(power, maxPower))
		elseif setting == "PERCENT" then
			textCenter:SetText(GetPowerPercentText(power, maxPower))
		elseif setting == "BOTH" then
			textLeft:SetText(GetPowerText(power, maxPower))
			textRight:SetText(GetPowerPercentText(power, maxPower))
		end
	end

	frame:RegisterEvent("CVAR_UPDATE")
	frame:RegisterEvent("UNIT_POWER_UPDATE")
	frame:SetScript("OnEvent", function(_, event, unit)
		if event == "UNIT_POWER_UPDATE" and unit ~= "player" then return end
		UpdateStatusText()
	end)

	UpdateStatusText()

	return frame
end
